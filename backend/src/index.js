require('dotenv').config();

const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth');
const accountRoutes = require('./routes/accounts');
const transferRoutes = require('./routes/transfers');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/accounts', accountRoutes);
app.use('/api/transfers', transferRoutes);

// Health check
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// 404 handler
app.use((_req, res) => {
  res.status(404).json({ error: 'Route bulunamadı.' });
});

// Global error handler
app.use((err, _req, res, _next) => {
  console.error('Unhandled error:', err.message);
  res.status(500).json({ error: 'Beklenmeyen bir hata oluştu.' });
});

app.listen(PORT, () => {
  console.log(`Bank API sunucusu http://localhost:${PORT} adresinde çalışıyor.`);
});
