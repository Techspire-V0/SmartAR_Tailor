import * as Yup from "yup";
import { HttpError } from "../utils/error";
import { SignInSchema, SignUpSchema } from "../types/auth";
import conts from "../types/conts";
import { NextFunction, Request, Response } from "express";
import { AuthenticatedRequest } from "./user";

class Validator {
  public async signIn(data: any) {
    try {
      await SignInSchema.validate(data);
    } catch (error) {
      throw new HttpError((error as any).message, 400);
    }
  }

  public async signUpGoogle(data: any) {
    try {
      await Yup.object({
        idToken: Yup.string().required("Google ID is required"),
      }).validate(data);
    } catch (error) {
      throw new HttpError((error as any).message, 400);
    }
  }

  public async signUp(data: any) {
    try {
      await SignUpSchema.validate(data);
    } catch (error) {
      throw new HttpError((error as any).message, 400);
    }
  }

  public catchError = <
    T extends (
      req: AuthenticatedRequest,
      res: Response,
      next: NextFunction
    ) => Promise<any>
  >(
    fn: T
  ) => {
    return async (
      req: AuthenticatedRequest,
      res: Response,
      next: NextFunction
    ) => {
      try {
        await fn(req, res, next);
      } catch (err) {
        let status = 500;
        let error = conts.errors.server;

        if (err instanceof HttpError) {
          error = err.message;
          status = err.status;
        }

        res.status(status).send(error);
      }
    };
  };
}

export const validator = new Validator();
