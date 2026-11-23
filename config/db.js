import 'dotenv/config';
import mysql from "mysql2/promise";

const conn = await mysql.createConnection({
   host: process.env.DB-HOST,
   user: process.env.DB-USER,
   password: process.env.DB-PASSWORD,
   database: process.env.DB-NAME,
});

conn.close();
