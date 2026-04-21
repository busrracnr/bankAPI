const express = require('express');
const pool = require('../config/db');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// Tüm route'lar JWT ile korunuyor
router.use(authenticateToken);

// GET /api/accounts  — kullanıcının hesaplarını listele
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT id, name, iban, balance, currency, account_type, is_active, created_at
       FROM accounts
       WHERE user_id = $1 AND is_active = TRUE
       ORDER BY created_at ASC`,
      [req.user.id]
    );
    res.json({ accounts: result.rows });
  } catch (err) {
    console.error('accounts list error:', err.message);
    res.status(500).json({ error: 'Sunucu hatası.' });
  }
});

// GET /api/accounts/lookup?iban=TR...  — IBAN'a göre hesap sahibi sorgula
router.get('/lookup', async (req, res) => {
  const { iban } = req.query;
  if (!iban) {
    return res.status(400).json({ error: 'IBAN parametresi gereklidir.' });
  }
  try {
    const result = await pool.query(
      `SELECT u.full_name
       FROM accounts a
       JOIN users u ON u.id = a.user_id
       WHERE a.iban = $1 AND a.is_active = TRUE`,
      [iban.toUpperCase()]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Bu IBAN\'a ait hesap bulunamadı.' });
    }
    res.json({ full_name: result.rows[0].full_name });
  } catch (err) {
    console.error('iban lookup error:', err.message);
    res.status(500).json({ error: 'Sunucu hatası.' });
  }
});

// GET /api/accounts/:id  — tek hesap detayı
router.get('/:id', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT id, name, iban, balance, currency, account_type, is_active, created_at
       FROM accounts
       WHERE id = $1 AND user_id = $2`,
      [req.params.id, req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Hesap bulunamadı.' });
    }

    res.json({ account: result.rows[0] });
  } catch (err) {
    console.error('account detail error:', err.message);
    res.status(500).json({ error: 'Sunucu hatası.' });
  }
});

// POST /api/accounts  — yeni hesap aç
router.post('/', async (req, res) => {
  const { name, currency, account_type } = req.body;

  if (!name) {
    return res.status(400).json({ error: 'Hesap adı zorunludur.' });
  }

  const validTypes = ['checking', 'savings', 'gold'];
  const type = validTypes.includes(account_type) ? account_type : 'checking';

  const validCurrencies = ['TRY', 'USD', 'EUR', 'GR'];
  const curr = validCurrencies.includes(currency) ? currency : 'TRY';

  // Basit IBAN üretici (gerçek IBAN algoritması değil)
  const randomPart = Math.random().toString().slice(2, 24).padEnd(22, '0');
  const iban = `TR${randomPart}`;

  try {
    const result = await pool.query(
      `INSERT INTO accounts (user_id, name, iban, currency, account_type)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING id, name, iban, balance, currency, account_type, created_at`,
      [req.user.id, name, iban, curr, type]
    );
    res.status(201).json({ account: result.rows[0] });
  } catch (err) {
    console.error('account create error:', err.message);
    res.status(500).json({ error: 'Sunucu hatası.' });
  }
});

module.exports = router;
