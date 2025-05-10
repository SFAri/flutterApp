import express from "express";
import configs from "./src/configs/index.js";
const {
  app: { port, host },
} = configs;
import { databaseConnection } from "./src/infras/index.js";
import expressApp from "./src/app.js";

const StartServer = async () => {
  const app = express();

  // connect to database
  await databaseConnection();

  await expressApp(app);

  app.listen(port, () => {
    console.log(
      `Server running at http://${host}:${port}; ` + `Press Ctrl + C to stop `
    );
  });
};

StartServer();
