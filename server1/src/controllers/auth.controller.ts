import { InferType } from "yup";
import { SignInSchema, SignUpSchema } from "../types/auth";
import { validator } from "../middlewares/validators";
import bcrypt from "bcryptjs";
import middleware from "../middlewares";
import { db } from "../db/connect";
import utils from "../utils";
import { Response } from "express";
import { AuthenticatedRequest } from "../middlewares/user";
import { OAuth2Client } from "google-auth-library";
import jwt from "jsonwebtoken";
import { HttpError } from "../utils/error";
import conts from "../types/conts";

const REFRESH_SECRET = process.env.JWT_REFRESH_SECRET!;

const client = new OAuth2Client(
  process.env.GOOGLE_CLIENT_ID,
  process.env.GOOGLE_CLIENT_SECRET
);

export const signup = validator.catchError(
  async (req: AuthenticatedRequest, res: Response) => {
    console.log(req.body);
    await validator.signUp(req.body);

    const { password, email, name } = req.body as any as InferType<
      typeof SignUpSchema
    >;

    await middleware.alreadySignedUp(email.trim());
    await middleware.alreadySignedIn(req.user);

    // hash password
    const pwd = await bcrypt.hash(password, 12);

    req.user = await db.user.create({
      data: {
        pwd,
        email,
        name,
        roles: [0],
      },
      select: {
        email: true,
        name: true,
        roles: true,
        verified: true,
      },
    });

    const tokens = await utils.generateAuthJWT(email);

    res.statusMessage = "Login successful";
    res.status(200).json({ token: tokens, user: req.user });
  }
);

export const signin = validator.catchError(
  async (req: AuthenticatedRequest, res: Response) => {
    await validator.signIn(req.body);

    const { password, email } = req.body as any as InferType<
      typeof SignInSchema
    >;

    req.user = await middleware.checkLoginCredentials(email, password);

    const tokens = await utils.generateAuthJWT(email);

    res.statusMessage = "Login successful";
    res.status(200).json({ token: tokens, user: req.user });
  }
);

export const googleAuth = validator.catchError(
  async (req: AuthenticatedRequest, res: Response) => {
    await validator.signUpGoogle(req.body);

    const { idToken } = req.body;
    const ticket = await client.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });
    const payload = ticket.getPayload();
    const email = payload?.email!;
    const name = payload?.name;

    await middleware.alreadySignedIn(req.user);

    const user = await db.user.findUnique({
      where: { email: email },
      select: { email: true, name: true, roles: true, verified: true },
    });

    if (user) {
      req.user = user;
    } else {
      req.user = await db.user.create({
        data: { email, name: name as string, roles: [0] },
        select: {
          email: true,
          name: true,
          roles: true,
          verified: true,
        },
      });
    }

    const tokens = await utils.generateAuthJWT(email);
    res.statusMessage = "Signed In successful";
    res.status(200).json({ token: tokens, user: req.user });
  }
);

export const trySignIn = validator.catchError(
  async (req: AuthenticatedRequest, res: Response) => {
    await middleware.checkUser(req.user);
    res.status(200).json(req.user);
  }
);

export const refreshToken = validator.catchError(
  async (req: AuthenticatedRequest, res: Response) => {
    const token = req.body?.token;

    const payload = jwt.verify(token, REFRESH_SECRET) as { email: string };
    const stored = await db?.user.findFirst({
      where: { email: payload?.email },
    });
    if (!stored || stored.refreshToken !== token) {
      throw new HttpError(conts.errors.unAuthenticated, 401);
    }

    const tokens = await utils.generateAuthJWT(payload.email);
    res.status(200).json(tokens);
  }
);
