import ConnectToMongo from './db.js'
import router from './node_code/login.js'
import express from 'express'   
import messRouter from './node_code/chat.js'
import { httpServer,app } from './authentication/sockets.js'
import cors from 'cors'
  const port = 3000
  ConnectToMongo();
  app.use(express.json()) 
  app.use(cors());
  app.use("/user",router)
  app.use('/chat',messRouter);
  app.get('/', (req, res) => {
    res.send('Hello World!')
  })

  httpServer.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
  })