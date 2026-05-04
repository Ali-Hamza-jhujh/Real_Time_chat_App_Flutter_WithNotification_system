import mongoose from 'mongoose'
import dotenv from 'dotenv'
dotenv.config();

const ConnectToMongo = async () => {
  mongoose.connect(process.env.DB_URL)
    .then(() => console.log('MongoDB Connected Successfully'))
    .catch((err) => console.log('Connection Failed:', err.message))
}
export default ConnectToMongo