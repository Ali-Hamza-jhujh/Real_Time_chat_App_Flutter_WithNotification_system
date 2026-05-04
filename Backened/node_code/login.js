import express from 'express'
import bcrypt from 'bcryptjs'
import User from '../models/login_model.js'
import jwt from 'jsonwebtoken'
import dotenv from 'dotenv'
dotenv.config();
const router = express.Router()
router.post('/login', async (req, res) => {
   console.log(req.body);

  try {
    const { email, password } = req.body
    if(!email||!password)return res.status(400).json({ message: 'All fields required' })
    const user = await User.findOne({ email })
  
    if (!user) return res.status(404).json({ message: 'User not found' })
      const hashPass = await bcrypt.compare(password, user.password);
      
    if (!hashPass) return res.status(400).json({ message: 'Wrong password' })
       const token=jwt.sign({id:user._id,email:user.email},process.env.SECRET_KEY,{expiresIn:'1h'})
res.status(200).json({
  token,
  userId: user._id.toString(),
  fname: user.fname,
  lname: user.lname
})
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message })
  }
})
router.post('/register', async (req, res) => {
   console.log(req.body);
  try {
    const { fname,lname,email, password } = req.body
    const user = await User.findOne({ email })
    if (user) return res.status(400).json({ message: 'User already register' })
      const hashPass = await bcrypt.hash(password,10);
   const newuser=await User.create({fname,lname,email,password:hashPass});
   if(newuser)
    res.status(200).json({ message: 'Register successful' })
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message })
  }
})

export default router