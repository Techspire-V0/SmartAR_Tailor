import express from "express";
import cookieParser from "cookie-parser";
import session from "express-session";
import "dotenv/config";
import { authenticate } from "./middlewares/user";
import {
  googleSignIn,
  googleSignUp,
  refreshToken,
  signin,
  signup,
} from "./controllers/auth.controller";

const { PORT, NODE_ENV, HOST } = process.env;
const isProduction = NODE_ENV === "production";

const app = express();

if (isProduction) {
  app.set("trust proxy", 1);
}

(async () => {
  app.use(express.urlencoded({ extended: true }));
  app.use(express.json());

  app.use(authenticate);

  app.post("/api/sign_in", signin);
  app.post("/api/google/sign_in", googleSignIn);

  app.post("/api/sign_up", signup);
  app.post("/api/google/sign_up", googleSignUp);

  app.post("/api/refresh_token", refreshToken);

  app.listen(PORT, () => {
    console.log(`Server is running at http://${HOST}:${PORT}`);
  });
})();
