import { serve } from "bun";
import mysql from "mysql2/promise";

const dbConfig = {
  host: process.env.DB_HOST || "mysql",
  user: "appuser",
  password: "apppass",
  database: "appdb",
  port: 3306,
};

serve({
  port: 3002,
  fetch: async () => {
    const conn = await mysql.createConnection(dbConfig);
    const [rows] = await conn.query(
      "SELECT item FROM todos ORDER BY RAND() LIMIT 1"
    );
    await conn.end();

    const todo = rows.length ? rows[0].item : "no data";
    return new Response(
      JSON.stringify({ todo }),
      {
        headers: { "Content-Type": "application/json" },
        status: 200,
      }
    );
  },
});
