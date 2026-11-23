import mysql from "mysql2/promise";
require ('dotenv').config();

const conn = await mysql.createConnection({
   host: process.env.DB-HOST,
   user: process.env.DB-USER,
   Password: process.env.DB-PASSWORD,
   database: process.env.DB-NAME,
});

conn.close();