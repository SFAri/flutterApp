import { config as _config } from "dotenv";

// Determine the environment and load the corresponding environment file
const env_val = process.env.NODE_ENV || "production";
// console.log(env_val);
const envFilePath = env_val == "development" ? ".env.development" : ".env";
// console.log(envFilePath);

// Load environment-specific variables
_config({ path: envFilePath });

const configs = {
  app: {
    port: process.env.PORT || 3000,
    host: process.env.HOST || "localhost" || "127.0.0.1",
  },
  db: {
    mongoURL: process.env.MONGO_URI || "mongodb://localhost:27017/user-service",
  },
  secret_key: {
    my_secret_key: process.env.SECRET_KEY,
  },
  tokens: {
    access_token_key: process.env.ACCESS_TOKEN_SECRET,
    access_token_expiration: "1h",
    refresh_token_key: process.env.REFRESH_TOKEN_SECRET,
    refresh_token_expiration: "1d",
  },
  salt_round: process.env.BCRYPT_SALT_ROUND,
};

export default configs;
