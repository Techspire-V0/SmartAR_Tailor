import { NextFunction, Request, Response } from "express";
import jwt, { JwtPayload } from "jsonwebtoken";
import { db } from "../db/connect";
import { MiniUser } from "../types/auth";

export interface AuthenticatedRequest extends Request {
  user?: MiniUser | null;
}

export const authenticate = async (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      throw new Error();
    }

    const token = authHeader.split(" ")[1];
    const secret = process.env.JWT_ACCESS_SECRET!;

    const decoded = jwt.verify(token, secret) as JwtPayload;

    const user = await db.user.findUnique({
      where: { email: decoded?.email },
    });

    if (!user) throw new Error();

    req.user = user;
    next();
  } catch (err) {
    req.user = null;
    next();
  }
};
