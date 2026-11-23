
import bcrypt from 'bcryptjs';
import rateLimit from 'express-rate-limit';

const express = require('express');
const db = require('../config/db');
const router = express.Router();


//function to get all distinct categories from the skin table
async function getCategories() {
  const [rows] = await db.execute('SELECT DISTINCT category FROM skin ORDER BY category');
  return rows.map(r => r.category);
}

//route to search skins by name or weapon name, with optional category filter
router.get('/search', async (req, res, next) => {
  try {
    const search_query = (req.query.q || '').trim();
    const categories = await getCategories();
    //only accept a category that actually exists in the table
    const category = categories.includes(req.query.category) ? req.query.category : '';

    //match with search query in skinName or weaponName, and filter by category if provided
    let sql_query = `SELECT skinId, skinName, category, weaponName, radianites, description, stock, rating, imageOne
                     FROM skin WHERE (skinName LIKE ? OR weaponName LIKE ?)`;
    const params = [`%${search_query}%`, `%${search_query}%`]; //two parameters (name and weapon name) for the LIKE clause

    if (category) {
      sql_query += ' AND category = ?';
      params.push(category);
    }
    sql_query += ' ORDER BY skinId';

    //execute the query (safe from SQL injection) & render the search results page with the matching skins
    const [skins] = await db.execute(sql_query, params);
    res.render('search', { title: 'Search', skins, q: search_query, category, categories });
  } catch (e) { next(e); }
});


//route to render the about page
router.get('/about', (req, res) => {
  res.render('about', { title: 'About Us' });
});

//route to render the contact page
router.get('/contact', (req, res) => {
  res.render('contact', { title: 'Contact Us' });
});

//route to render the FAQ page
router.get('/faq', (req, res) => {
  res.render('faq', { title: 'FAQ' });
});

//rate limiter for login attempts (max 4 failed attempts in 17 minutes)
const login_limit = rateLimit({
  windowMs: 17 * 60 * 1000, //time window of 17 minutes
  max: 4,  //maximum number of failed attempts allowed
  skipSuccessfulRequests: true,  //only count failed attempts
  handler: (req, res) =>
    res.status(429).render('login', {
      title: 'Log In',
      errors: ['Too many failed attempts! Try again in 17 minutes.'],
      values: {},
    }),
});

//route to render the login page
router.get('/login', (req, res) => {
  res.render('login', { title: 'Log In', errors: [], values: {} });
});

//route to handle login form submission with rate limiting
router.post('/login', login_limit, async (req, res, next) => {
  try {
    const identifier = (req.body.identifier || '').trim();
    const password = req.body.password || '';

    const is_email = identifier.includes('@'); //determine if the identifier is an email or phone number
    const column = is_email ? 'email' : 'phone'; 
    //normalize the identifier for comparison (lowercase for email, remove spaces and hyphens for phone)
    const value = is_email ? identifier.toLowerCase() : identifier.replace(/[\s-]/g, '');
    
    //query the database for a customer with the given email or phone number
    const [rows] = await db.execute(
      `SELECT custId, custName, password FROM customer WHERE ${column} = ?`,
      [value]
    );

    //check if a matching user was found and if the password matches the hashed password in the database
    const ok = rows.length > 0 && (await bcrypt.compare(password, rows[0].password));
    if (!ok) {
      return res.status(401).render('login', {
        title: 'Log In',
        errors: ['Incorrect login details.'],
        values: { identifier },
      });
    }

    // need to do (later, with sessions):
    res.redirect('/');
  } catch (err) { next(err); }
});