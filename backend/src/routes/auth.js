const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const pool = require('../config/db');

const router = express.Router();

// POST /api/auth/register
router.post('/register', async (req, res) => {
  const { full_name, email, password, phone } = req.body;

  if (!full_name || !email || !password) {
    return res.status(400).json({ error: 'Ad, e-posta ve şifre zorunludur.' });
  }

  if (password.length < 8) {
    return res.status(400).json({ error: 'Şifre en az 8 karakter olmalıdır.' });
  }

  try {
    const existing = await pool.query('SELECT id FROM users WHERE email = $1', [email]);
    if (existing.rows.length > 0) {
      return res.status(409).json({ error: 'Bu e-posta zaten kayıtlı.' });
    }

    const saltRounds = 12;
    const password_hash = await bcrypt.hash(password, saltRounds);

    const client = await pool.connect();
    try {
      await client.query('BEGIN');

      const result = await client.query(
        `INSERT INTO users (full_name, email, password_hash, phone)
         VALUES ($1, $2, $3, $4)
         RETURNING id, full_name, email, phone, created_at`,
        [full_name, email, password_hash, phone || null]
      );

      const user = result.rows[0];

      // Kullanıcıya özel IBAN üret (TR + 24 rakam, userId'nin ilk 8 karakteri gömülü)
      const userIdPart = user.id.replace(/-/g, '').slice(0, 8).toUpperCase();
      const randomPart = Math.floor(Math.random() * 1e16).toString().padStart(16, '0');
      const iban = `TR${userIdPart}${randomPart}`;

      // Otomatik vadesiz hesap aç, bakiye 0
      await client.query(
        `INSERT INTO accounts (user_id, name, iban, balance, currency, account_type)
         VALUES ($1, 'Vadesiz Hesap', $2, 0, 'TRY', 'checking')`,
        [user.id, iban]
      );

      await client.query('COMMIT');

      const token = jwt.sign(
        { id: user.id, email: user.email },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN }
      );

      res.status(201).json({ token, user });
    } catch (innerErr) {
      await client.query('ROLLBACK');
      throw innerErr;
    } finally {
      client.release();
    }
  } catch (err) {
    console.error('register error:', err.message);
    res.status(500).json({ error: 'Sunucu hatası.' });
  }
});

// POST /api/auth/login
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'E-posta ve şifre zorunludur.' });
  }

  try {
    const result = await pool.query(
      'SELECT id, full_name, email, phone, password_hash FROM users WHERE email = $1',
      [email]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'E-posta veya şifre hatalı.' });
    }

    const user = result.rows[0];
    const valid = await bcrypt.compare(password, user.password_hash);

    if (!valid) {
      return res.status(401).json({ error: 'E-posta veya şifre hatalı.' });
    }

    const token = jwt.sign(
      { id: user.id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );

    const { password_hash, ...safeUser } = user;
    res.json({ token, user: safeUser });
  } catch (err) {
    console.error('login error:', err.message);
    res.status(500).json({ error: 'Sunucu hatası.' });
  }
});

// GET /api/auth/me  (korumalı)
const { authenticateToken } = require('../middleware/auth');

router.get('/me', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT id, full_name, email, phone, created_at FROM users WHERE id = $1',
      [req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Kullanıcı bulunamadı.' });
    }

    res.json({ user: result.rows[0] });
  } catch (err) {
    console.error('me error:', err.message);
    res.status(500).json({ error: 'Sunucu hatası.' });
  }
});

module.exports = router;
