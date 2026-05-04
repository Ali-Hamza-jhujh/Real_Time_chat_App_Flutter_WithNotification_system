import { Server } from 'socket.io'
import express from 'express'
import { createServer } from 'http'

const app = express()
const httpServer = createServer(app)
const io = new Server(httpServer, {
  cors: { origin: "*" }
})

io.on('connection', (socket) => {
  console.log("✅ Connection established!", socket.id)

  socket.on('join', (id) => {
    const roomId = id.toString()
    socket.join(roomId)
    console.log(`✅ User joined room: ${roomId}`)
  })

 

  socket.on('disconnect', () => {
    console.log("❌ User disconnected", socket.id)
  })
})

export { io, app, httpServer }