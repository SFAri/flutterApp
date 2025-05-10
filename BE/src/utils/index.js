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
  if (data?.pagination) {
    return {
      status,
      data: data.data,
      paginate: data.pagination,
    };
  }

  return {
    status,
    data,
  };
}

export function CheckMissingFields(fields = {}) {
  const missingFields = [];

  for (const [field, value] of Object.entries(fields)) {
    if (!value) {
      missingFields.push(field);
    }
  }

  if (missingFields.length > 0) {
    ThrowNewError("MissingFields", `${missingFields.join(", ")} is missing`);
  }
}

export function ThrowNewError(name, message) {
  const error = new Error(message);
  error.name = name;
  throw error;
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
