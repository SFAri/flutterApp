import jwt from "jsonwebtoken";
const { sign: _sign, verify: _verify } = jwt;
import { genSalt, hash, compare } from "bcrypt";
import { promisify } from "util";
const sign = promisify(_sign).bind(jwt);
const verify = promisify(_verify).bind(jwt);

import configs from "../configs/index.js";
const { salt_round } = configs;

export function FormatData(data) {
  if (data === undefined) {
    throw new Error("Data not found");
  }
  return data;
}

export function FormatResult(status, data) {
  if (status === undefined || data === undefined) {
    throw new Error("Result not found");
  }
  return {
    status,
    data,
  };
}

// Encrypt password
export async function EncryptPass(password) {
  const salt = await genSalt(parseInt(salt_round));
  const encryptPassword = await hash(password, salt);
  return encryptPassword;
}

export async function ComparePass(password, passwordEncrypt) {
  const isPasswordValid = await compare(password, passwordEncrypt);
  if (!isPasswordValid) return false;
  return true;
}

export async function GenerateToken(payload, secretSignature, tokenLife) {
  try {
    return await sign({ payload }, secretSignature, {
      algorithm: "HS256",
      expiresIn: tokenLife,
    });
  } catch (err) {
    console.log(`Error in generate access token:  + ${err}`);
    return null;
  }
}

export async function VerifyToken(token, secretKey) {
  try {
    return await verify(token, secretKey);
  } catch (err) {
    console.log(`Error in verify token:  + ${err}`);
    return null;
  }
}

export async function DecodeToken(token, secretKey) {
  try {
    return await verify(token, secretKey, { ignoreExpiration: true });
  } catch (err) {
    console.log(`Error in decode token: ${err}`);
    return null;
  }
}
