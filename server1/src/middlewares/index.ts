import { User } from "@prisma/client";
import { HttpError } from "../utils/error";
import { db } from "../db/connect";
import bcrypt from "bcryptjs";
import consts from "../types/conts";

class MiddleWare {
  public checkUser(user: User | null) {
    if (!!user) {
      throw new HttpError(consts.errors.signIn, 401);
    }
  }

  public async checkLoginCredentials(
    email: string,
    password?: string
  ): Promise<User> {
    const user = await db.user.findUnique({ where: { email } });

    if (!user) {
      throw new HttpError(consts.errors.invalidSignIn, 400);
    }

    if (password) {
      const isMatched = await bcrypt.compare(password, user.pwd);
      if (!isMatched) {
        throw new HttpError(consts.errors.invalidSignIn, 400);
      }
    }
    return user;
  }

  public async alreadySignedUp(email: string): Promise<void> {
    const user = await db.user.findUnique({ where: { email } });
    if (user) {
      throw new HttpError(consts.errors.userAlreadyExist, 400);
    }
  }

  public async alreadySignedIn(user: User | null | undefined): Promise<void> {
    if (!!user) {
      throw new HttpError(consts.errors.alreadySignedIn, 400);
    }
  }
}

const middleware = new MiddleWare();
export default middleware;
