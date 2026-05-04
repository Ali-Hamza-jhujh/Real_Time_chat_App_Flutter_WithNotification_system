import Chat from '../models/messagemodel.js'
import User from '../models/login_model.js'
import express from 'express'
import Authentication from '../authentication/auth.js'
import { io } from '../authentication/sockets.js'

const messRouter = express.Router()

messRouter.post('/sendmessage/:receiverId', Authentication, async (req, res) => {
  console.log("Received")
  const receiverId = req.params.receiverId
  const senderId = req.user.id

  try {
    const { mess } = req.body
    if (!mess) return res.status(400).json({ message: "Message is required" })

    const sender = await User.findById(senderId)
    if (!sender) return res.status(404).json({ message: "Sender does not exist" })

    const receiver = await User.findById(receiverId)
    if (!receiver) return res.status(404).json({ message: "Receiver does not exist" })

    const message = new Chat({
      message: mess,
      sender: senderId,
      receiver: receiverId
    })
    await message.save()

    const payload = {
      message: mess,
      sender: senderId.toString(),     // ✅ FIXED: was senderId (ObjectId)
      receiver: receiverId.toString(),  // ✅ FIXED: was receiverId (ObjectId)
      createdAt: message.createdAt
    }

    io.to(receiverId.toString()).emit('newmessage', payload)  // ✅ FIXED
    io.to(senderId.toString()).emit('newmessage', payload)    // ✅ FIXED

    res.status(200).json({ message: "Message sent successfully" })
  } catch (e) {
    res.status(500).json({ message: e.message })
  }
})

messRouter.get('/allusers', Authentication, async (req, res) => {
  try {
    const loggedInUser = req.user.id
    const users = await User.find({ _id: { $ne: loggedInUser } })
      .select('-password')
    res.status(200).json({ message: "All users", users })
  } catch (e) {
    res.status(500).json({ message: e.message })
  }
})
messRouter.delete('/message/:id',Authentication,async(req,res)=>{
  try{
  const id=req.params.id;
  const message=await Chat.findByIdAndDelete(id);
 if (!message) {
      return res.status(404).json({ message: "Message not found" });
    }
  res.status(200).json({message:"messgae deleted successfuly"});
  }catch(e){
 res.status(500).json({ message: e.message })
  }
});
messRouter.get('/messages/:receiverId', Authentication, async (req, res) => {
  try {
    const senderId = req.user.id
    const receiverId = req.params.receiverId

    const messages = await Chat.find({
      $or: [
        { sender: senderId, receiver: receiverId },
        { sender: receiverId, receiver: senderId },
      ]
    })
      .lean()
      .sort({ createdAt: 1 })

    const formatted = messages.map(m => ({
      ...m,
      sender: m.sender.toString(),
      receiver: m.receiver.toString()
    }))

    res.status(200).json({ messages: formatted })
  } catch (e) {
    res.status(500).json({ message: e.message })
  }
})

export default messRouter