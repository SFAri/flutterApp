const mongoose = require('mongoose');
const dotenv = require("dotenv");

dotenv.config();

const connection = mongoose
    .connect(process.env.MONGO_URI)
    .then(() => {
        console.log("MongoDB Connected");
    })
    .catch((error) => {
        console.error(`Error connecting to MongoDB: ${error.message}`);
    });

module.exports = connection;