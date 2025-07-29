import jwt from "jsonwebtoken";
import { db } from "../db/connect";

const ACCESS_SECRET = process.env.JWT_ACCESS_SECRET!;
const REFRESH_SECRET = process.env.JWT_REFRESH_SECRET!;

class Utils {
  public verifyJWT = async (token: any, secret: any) => {
    const decoded: string | jwt.JwtPayload | undefined = await new Promise(
      (resolve) => {
        jwt.verify(token as string, secret as string, (err, val) => {
          if (!err) {
            resolve(undefined);
          } else {
            resolve(val);
          }
        });
      }
    );

    return decoded;
  };

  public generateAuthJWT = async (email: string) => {
    const accessToken = jwt.sign({ email }, ACCESS_SECRET, {
      expiresIn: "15m",
    });
    const refreshToken = jwt.sign({ email }, REFRESH_SECRET, {
      expiresIn: "7d",
    });

    await db.user.update({ where: { email }, data: { refreshToken } });
    return { accessToken, refreshToken };
  };

  public paginate = (count: number, take: number, skip: number) => {
    const page = Math.ceil((skip + take) / take);
    const numPages = Math.ceil(count / take);
    return { skip, page, numPages, take, count };
  };
}

const utils = new Utils();
export default utils;
