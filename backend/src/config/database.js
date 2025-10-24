import mongoose from "mongoose";

export const db_connect = async () => {
  try {
    const connect = await mongoose.connect(process.env.MONGO_URL);
    if (connect) {
      console.log(connect.connection.host, "connected to DB");
    }
  } catch (error) {
    console.log(error.message, "Failed to connect to DB");
  }
};
