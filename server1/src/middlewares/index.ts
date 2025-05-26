import { User } from "@prisma/client";
import { HttpError } from "../utils/error";
import { db } from "../db/connect";
import bcrypt from "bcryptjs";
import consts from "../types/conts";
import { MiniUser } from "../types/auth";

class MiddleWare {
  public checkUser(user?: MiniUser | null) {
    if (!user) {
      throw new HttpError(consts.errors.signIn, 401);
    }
  }

  public async checkLoginCredentials(
    email: string,
    password?: string
  ): Promise<MiniUser> {
    const user = await db.user.findUnique({
      where: { email },
      select: {
        email: true,
        name: true,
        roles: true,
        verified: true,
        pwd: true,
      },
    });

    if (!user) {
      throw new HttpError(consts.errors.invalidSignIn, 400);
    }

    const { pwd, ...rest } = user;

    if (password) {
      if (!user?.pwd) {
        throw new HttpError(consts.errors.invalidSignIn, 400);
      }

      const isMatched = await bcrypt.compare(password, user.pwd);
      if (!isMatched) {
        throw new HttpError(consts.errors.invalidSignIn, 400);
      }
    }
    return rest;
  }

  public async alreadySignedUp(email: string): Promise<void> {
    const user = await db.user.findUnique({ where: { email } });
    if (user) {
      throw new HttpError(consts.errors.userAlreadyExist, 400);
    }
  }

  public async alreadySignedIn(
    user: MiniUser | null | undefined
  ): Promise<void> {
    if (!!user) {
      throw new HttpError(consts.errors.alreadySignedIn, 400);
    }
  }
}

const middleware = new MiddleWare();
export default middleware;
