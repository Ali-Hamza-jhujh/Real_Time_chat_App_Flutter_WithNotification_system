
import jwt from 'jsonwebtoken'

const Authentication=(req,res,next)=>{
    const auth=req.headers['authorization'];
    if(!auth){
        return res.status(401).json({message:"No token provided"})
    }
    try{
const token=auth.split(' ')[1];
if(!token){
     return res.status(401).json({message:"Token not found"})
}
const corect= jwt.verify(token,process.env.SECRET_KEY);
if(!corect){
     return res.status(401).json({message:"Token mismatch"})
}
req.user=corect;
next();
    }
    catch(e){
        res.status(400).json({message:`${e.message}`})
    }
    

}

export default Authentication