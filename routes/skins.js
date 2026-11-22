

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