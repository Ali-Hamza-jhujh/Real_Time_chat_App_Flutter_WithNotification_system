import mongoose from 'mongoose'
const { Schema } = mongoose

const chatSchema = new Schema({
  message:  { type: String, required: true },
  sender:   { type: mongoose.Schema.Types.ObjectId, ref: 'Users', required: true },
  receiver: { type: mongoose.Schema.Types.ObjectId, ref: 'Users', required: true },
}, { timestamps: true }) // ✅ adds createdAt

export default mongoose.model("Chat", chatSchema)