const express = require('express');
const cors = require('cors');
const { createClient } = require('@supabase/supabase-js');
const multer = require('multer');
const csv = require('csv-parse');
const { Readable } = require('stream');
require('dotenv').config();

// Debug logging
console.log('Environment variables:');
console.log('PORT:', process.env.PORT);
console.log('SUPABASE_URL:', process.env.SUPABASE_URL ? 'Set' : 'Not set');
console.log('SUPABASE_SERVICE_KEY:', process.env.SUPABASE_SERVICE_KEY ? 'Set' : 'Not set');

const app = express();
const port = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Initialize Supabase client
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

// Configure multer for file uploads
const upload = multer({
  storage: multer.memoryStorage(),
  fileFilter: (req, file, cb) => {
    if (file.mimetype === 'text/csv') {
      cb(null, true);
    } else {
      cb(new Error('Only CSV files are allowed'));
    }
  }
});

// Helper function to parse CSV
const parseCSV = (buffer) => {
  return new Promise((resolve, reject) => {
    const records = [];
    const parser = csv.parse({
      columns: true,
      skip_empty_lines: true,
      trim: true
    });

    parser.on('readable', () => {
      let record;
      while ((record = parser.read()) !== null) {
        records.push(record);
      }
    });

    parser.on('error', (err) => reject(err));
    parser.on('end', () => resolve(records));

    const stream = Readable.from(buffer);
    stream.pipe(parser);
  });
};

// Routes
app.get('/api/contacts', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('contacts')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) throw error;
    res.json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/contacts', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('contacts')
      .insert([req.body])
      .select();

    if (error) throw error;
    res.json(data[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.put('/api/contacts/:id', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('contacts')
      .update(req.body)
      .eq('id', req.params.id)
      .select();

    if (error) throw error;
    res.json(data[0]);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.delete('/api/contacts/:id', async (req, res) => {
  try {
    const { error } = await supabase
      .from('contacts')
      .delete()
      .eq('id', req.params.id);

    if (error) throw error;
    res.json({ message: 'Contact deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Bulk import endpoint
app.post('/api/contacts/import', upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      throw new Error('No file uploaded');
    }

    if (!req.body.mapping) {
      throw new Error('Column mapping is required');
    }

    const mapping = JSON.parse(req.body.mapping);
    const records = await parseCSV(req.file.buffer);
    
    // Transform records using the provided mapping
    const contacts = records.map(record => {
      const contact = {};
      
      // Map each field using the provided mapping
      Object.entries(mapping).forEach(([dbField, csvColumn]) => {
        if (csvColumn && record[csvColumn] !== undefined) {
          // Handle special field types
          switch (dbField) {
            case 'subscription_date':
            case 'unsubscription_date':
            case 'birthday':
            case 'latest_interaction':
              contact[dbField] = record[csvColumn] ? new Date(record[csvColumn]) : null;
              break;
            case 'subscription_status_email':
            case 'subscription_status_sms':
              contact[dbField] = record[csvColumn]?.toLowerCase() || 'pending';
              break;
            case 'buyer_preference':
              contact[dbField] = record[csvColumn]?.toLowerCase() || 'email';
              break;
            case 'tags':
              contact[dbField] = record[csvColumn] ? record[csvColumn].split(',').map(tag => tag.trim()) : [];
              break;
            default:
              contact[dbField] = record[csvColumn];
          }
        }
      });

      // Validate required fields
      const requiredFields = ['first_name', 'last_name', 'email'];
      const missingFields = requiredFields.filter(field => !contact[field]);
      
      if (missingFields.length > 0) {
        throw new Error(`Missing required fields: ${missingFields.join(', ')}`);
      }

      return contact;
    });

    // Insert contacts in batches of 100
    const batchSize = 100;
    const results = [];
    
    for (let i = 0; i < contacts.length; i += batchSize) {
      const batch = contacts.slice(i, i + batchSize);
      const { data, error } = await supabase
        .from('contacts')
        .insert(batch)
        .select();

      if (error) throw error;
      results.push(...data);
    }

    res.json({
      message: `Successfully imported ${results.length} contacts`,
      imported: results
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
}); 