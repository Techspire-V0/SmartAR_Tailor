import express from "express";
import "dotenv/config";
import fs from "fs";
import https from "https";
import { authenticate } from "./middlewares/user";
import {
  googleAuth,
  refreshToken,
  signin,
  signup,
  trySignIn,
} from "./controllers/auth.controller";
import morgan from "morgan";

const { PORT, NODE_ENV, HOST } = process.env;
const isProduction = NODE_ENV === "production";

const app = express();

if (isProduction) {
  app.set("trust proxy", 1);
}

(async () => {
  app.use(morgan("dev"));
  app.use(express.urlencoded({ extended: true }));
  app.use(express.json());

  app.use(authenticate);

  app.get("/api/auth/try_sign_in", trySignIn);
  app.post("/api/auth/sign_in", signin);
  app.post("/api/auth/sign_up", signup);

  app.post("/api/auth/google", googleAuth);
  app.post("/api/auth/refresh_token", refreshToken);

  if (!isProduction) {
    const options = {
      key: fs.readFileSync(__dirname + "/key.pem", { encoding: "utf8" }),
      cert: fs.readFileSync(__dirname + "/cert.pem", { encoding: "utf8" }),
    };
    const server = https.createServer(options, app);

    server.listen(PORT, () => {
      console.log(`Server is running at http://${HOST}:${PORT}`);
    });
  } else {
    app.listen(PORT, () => {
      console.log(`Server is running at http://${HOST}:${PORT}`);
    });
  }
})();
