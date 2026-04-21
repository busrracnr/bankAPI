const express = require('express');
const pool = require('../config/db');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

router.use(authenticateToken);

// GET /api/transfers  — kullanıcının gönderdiği transferler
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT t.id, t.sender_account_id, a.name AS sender_account_name,
              t.receiver_iban, t.receiver_name, t.amount, t.currency,
              t.description, t.status, t.created_at
       FROM transfers t
       JOIN accounts a ON a.id = t.sender_account_id
       WHERE a.user_id = $1
       ORDER BY t.created_at DESC
       LIMIT 100`,
      [req.user.id]
    );
    res.json({ transfers: result.rows });
  } catch (err) {
    console.error('transfers list error:', err.message);
    res.status(500).json({ error: 'Sunucu hatası.' });
  }
});

// GET /api/transfers/account/:accountId  — belirli hesabın transferleri
router.get('/account/:accountId', async (req, res) => {
  try {
    // Hesabın bu kullanıcıya ait olduğunu doğrula
    const ownerCheck = await pool.query(
      'SELECT id FROM accounts WHERE id = $1 AND user_id = $2',
      [req.params.accountId, req.user.id]
    );
    if (ownerCheck.rows.length === 0) {
      return res.status(403).json({ error: 'Bu hesaba erişim yetkiniz yok.' });
    }

    const result = await pool.query(
      `SELECT id, sender_account_id, receiver_iban, receiver_name,
              amount, currency, description, status, created_at
       FROM transfers
       WHERE sender_account_id = $1
       ORDER BY created_at DESC`,
      [req.params.accountId]
    );
    res.json({ transfers: result.rows });
  } catch (err) {
    console.error('account transfers error:', err.message);
    res.status(500).json({ error: 'Sunucu hatası.' });
  }
});

// POST /api/transfers  — para gönder
router.post('/', async (req, res) => {
  const { sender_account_id, receiver_iban, receiver_name, amount, description } = req.body;

  if (!sender_account_id || !receiver_iban || !amount) {
    return res.status(400).json({ error: 'Gönderen hesap, alıcı IBAN ve tutar zorunludur.' });
  }

  const parsedAmount = parseFloat(amount);
  if (isNaN(parsedAmount) || parsedAmount <= 0) {
    return res.status(400).json({ error: 'Tutar geçerli bir pozitif sayı olmalıdır.' });
  }

  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    // Gönderen hesabı kilitle ve doğrula
    const senderResult = await client.query(
      `SELECT id, balance, currency, user_id
       FROM accounts
       WHERE id = $1 AND is_active = TRUE
       FOR UPDATE`,
      [sender_account_id]
    );

    if (senderResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return res.status(404).json({ error: 'Gönderen hesap bulunamadı.' });
    }

    const sender = senderResult.rows[0];

    if (sender.user_id !== req.user.id) {
      await client.query('ROLLBACK');
      return res.status(403).json({ error: 'Bu hesap size ait değil.' });
    }

    if (parseFloat(sender.balance) < parsedAmount) {
      await client.query('ROLLBACK');
      return res.status(422).json({ error: 'Yetersiz bakiye.' });
    }

    // Bakiyeyi düş
    await client.query(
      'UPDATE accounts SET balance = balance - $1 WHERE id = $2',
      [parsedAmount, sender_account_id]
    );

    // Alıcı hesabı IBAN ile bul ve doğrula
    const receiverResult = await client.query(
      `SELECT a.id, a.iban, u.full_name
       FROM accounts a
       JOIN users u ON u.id = a.user_id
       WHERE a.iban = $1 AND a.is_active = TRUE
       FOR UPDATE`,
      [receiver_iban]
    );

    if (receiverResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return res.status(404).json({ error: 'Alıcı IBAN bulunamadı. Lütfen IBAN\'ı kontrol ediniz.' });
    }

    const receiverAccount = receiverResult.rows[0];

    // Eğer alıcı adı girilmişse, hesap sahibiyle karşılaştır
    if (receiver_name && receiver_name.trim() !== '') {
      const normalize = (s) => s.trim().toLowerCase().replace(/\s+/g, ' ');
      if (!normalize(receiverAccount.full_name).includes(normalize(receiver_name)) &&
          !normalize(receiver_name).includes(normalize(receiverAccount.full_name))) {
        await client.query('ROLLBACK');
        return res.status(422).json({ error: `Alıcı adı eşleşmiyor. Bu IBAN "${receiverAccount.full_name}" adına kayıtlıdır.` });
      }
    }

    // Alıcı hesaba bakiye ekle
    await client.query(
      'UPDATE accounts SET balance = balance + $1 WHERE id = $2',
      [parsedAmount, receiverAccount.id]
    );

    // Transfer kaydı oluştur
    const transferResult = await client.query(
      `INSERT INTO transfers
         (sender_account_id, receiver_iban, receiver_name, amount, currency, description, status)
       VALUES ($1, $2, $3, $4, $5, $6, 'completed')
       RETURNING *`,
      [
        sender_account_id,
        receiver_iban,
        receiver_name || null,
        parsedAmount,
        sender.currency,
        description || null,
      ]
    );

    await client.query('COMMIT');
    res.status(201).json({ transfer: transferResult.rows[0] });
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('transfer error:', err.message);
    res.status(500).json({ error: 'Transfer işlemi başarısız.' });
  } finally {
    client.release();
  }
});

module.exports = router;
