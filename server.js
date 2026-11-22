
require('dotenv').config(); //load environment variables from .env file

const path = require('node:path'); //import the path module to work with file and directory paths
const express = require('express');

const app = express();

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, 'public')));
app.use('/', require('./routes/skins'));

app.use((req, res) => res.status(404).send('Page not found!!')); 

//error handling middleware
app.use((e, req, res, next) => {
  console.error(e);
  res.status(500).send('Something went wrong or broke!!');
});

const port = process.env.PORT || 3000; //use the port from the .env file or default to 3000
app.listen(port, () => console.log(`Running at http://localhost:${port}`));