import mysql from "mysql2/promise";

const conn = await mysql.createConnection({
   host: "localhost",
   user: "root",
   password: "676767",
   database: "valorant-skin-store",
});

conn.close();