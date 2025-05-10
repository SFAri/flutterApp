import { connect } from "mongoose";
import configs from "../configs/index.js";
const {
  db: { mongoURL },
} = configs;

const connectDB = async () => {
  try {
    await connect(mongoURL, {
      dbName: "ecommere-app",
    });
    console.log("MongoDB connected ...");
  } catch (err) {
    console.error("Error ============ DB Connection");
    process.exit(1);
  }
};

export default connectDB;
