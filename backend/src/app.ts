import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import portfolioRoutes from "./routes/portfolioRoutes";
import bettingRoutes from "./routes/bettingRoutes";
import userRoutes from "./routes/userRoutes";
dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());
app.use("/api", portfolioRoutes);
app.use("/api", bettingRoutes);
app.use("/api", userRoutes);
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
