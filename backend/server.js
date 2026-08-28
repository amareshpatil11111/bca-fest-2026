const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const dotenv = require('dotenv');
const { createClient } = require('@supabase/supabase-js');

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

// Enable Middlewares
const corsOptions = {
  origin: function (origin, callback) {
    // Allow requests with no origin (e.g. curl, Postman) or from localhost
    if (!origin || origin.includes('localhost') || origin.includes('127.0.0.1')) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
};
app.use(cors(corsOptions));
app.options('*', cors(corsOptions)); // Handle preflight requests
app.use(express.json());
app.use(morgan('dev'));

// Initialize Supabase Client
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;

if (!supabaseUrl || !supabaseKey || supabaseUrl.includes('YOUR_') || supabaseKey.includes('YOUR_')) {
  console.warn('WARNING: Supabase URL and/or Key are not configured yet in the .env file.');
  console.warn('Standalone server running, but DB queries will fail until credentials are provided.');
}

const supabase = (supabaseUrl && supabaseKey) 
  ? createClient(supabaseUrl, supabaseKey) 
  : null;

// Health Check Endpoint
app.get('/', (req, res) => {
  res.json({
    status: 'healthy',
    message: 'BCA Fest 2026 Node.js Backend is running',
    supabaseConnected: !!supabase
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date() });
});

// POST /api/register - Register a participant
app.post('/api/register', async (req, res) => {
  try {
    const { name, email, phone } = req.body;

    // Validation checks
    if (!name || !email || !phone) {
      return res.status(400).json({ 
        success: false, 
        message: 'Name, email, and phone are required fields.' 
      });
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ 
        success: false, 
        message: 'Please provide a valid email address.' 
      });
    }

    if (!supabase) {
      // In development fallback/mock database logging when credentials are not configured
      console.log('--- [MOCK REGISTRATION DATABASE SAVE] ---');
      console.log(`Name:  ${name}`);
      console.log(`Email: ${email}`);
      console.log(`Phone: ${phone}`);
      console.log('------------------------------------------');
      return res.status(200).json({
        success: true,
        message: 'Registration logged successfully (Mock Standalone Mode)',
        data: { name, email, phone, created_at: new Date().toISOString() }
      });
    }

    // Insert into Supabase 'registrations' table
    const { data, error } = await supabase
      .from('registrations')
      .insert([{ name, email, phone }])
      .select();

    if (error) {
      console.error('Supabase DB Insert Error:', error.message);
      return res.status(500).json({ 
        success: false, 
        message: 'Database insertion failed.', 
        error: error.message 
      });
    }

    console.log('Participant registered successfully in Supabase:', data[0]);

    return res.status(201).json({
      success: true,
      message: 'Registration completed successfully!',
      data: data[0]
    });

  } catch (error) {
    console.error('Register Endpoint Error:', error);
    return res.status(500).json({ 
      success: false, 
      message: 'Internal server error.' 
    });
  }
});

// GET /api/registrations - Retrieve registered participants list
app.get('/api/registrations', async (req, res) => {
  try {
    if (!supabase) {
      return res.json({
        success: true,
        message: 'No Supabase connection. Running in standalone mock mode.',
        data: []
      });
    }

    const { data, error } = await supabase
      .from('registrations')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) {
      console.error('Supabase fetch error:', error.message);
      return res.status(500).json({ 
        success: false, 
        message: 'Could not fetch registrations from database.' 
      });
    }

    return res.json({
      success: true,
      count: data.length,
      data: data
    });

  } catch (error) {
    console.error('Registrations Fetch Error:', error);
    return res.status(500).json({ 
      success: false, 
      message: 'Internal server error.' 
    });
  }
});

// Start listening
app.listen(PORT, () => {
  console.log(`==================================================`);
  console.log(`Server is running on port ${PORT}`);
  console.log(`Health Check: http://localhost:${PORT}/health`);
  console.log(`Registration API: http://localhost:${PORT}/api/register`);
  console.log(`==================================================`);
});
