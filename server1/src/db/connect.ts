import { PrismaClient } from "@prisma/client";
import prismaRandom from "prisma-extension-random";
// Prevent multiple instances of Prisma Client in development
declare const globalThis: {
  prismaGlobal: ReturnType<typeof prismaClientSingleton>;
} & typeof global;

const prismaClientSingleton = () => {
  return new PrismaClient().$extends(prismaRandom());
};

export const db = globalThis.prismaGlobal ?? prismaClientSingleton();

if (process.env.NODE_ENV !== "production") globalThis.prismaGlobal = db;
