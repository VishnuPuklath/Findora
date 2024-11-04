const express=require('express');
const User = require('../models/user');
const bcryptjs=require('bcryptjs');
const authRouter=express.Router();
const jwt=require('jsonwebtoken');
const auth = require('../middleware/auth');


//signup
authRouter.post("/api/signup",async (req,res)=>{

try{
    const {name,email,password}=req.body;
    const existingUser=await User.findOne({email});
    if(existingUser){
        return res.status(400).json({msg:'User with same email already exists'});
    }
   const hashedPassword=await bcryptjs.hash(password,8);
    let user=await new User({email,name,password:hashedPassword});
    user=await user.save();
    res.json(user);
}catch(e){
res.status(500).json({error:e.message});
}

});

//signin

authRouter.post("/api/signin",async (req,res)=>{
try{
    const {email,password}=req.body;
    
    const user=await User.findOne({email});
    
    if(!user){
        return res.status(400).json({msg:'User with this email not found'});
    }
  const isMatch= await bcryptjs.compare(password,user.password);
  if(!isMatch){
    return res.status(400).json({msg:'Incorrect password'}); 
  }
 const token = jwt.sign({id:user._id},"passwordKey");
 return res.status(200).json({token,...user._doc});
}catch(e){
    return res.status(500).json({error:e.message});
}
});

//checking token is valid or not

authRouter.post("/isTokenValid",async (req,res)=>{
try{
const token=req.header('X-auth-token');
if(!token)return res.json(false);
const verified=jwt.verify(token,"passwordKey");
if(!verified)return res.json(false);
const user=await User.findById(verified.id);
if(!user)return res.json(false);
return res.json(true);
}catch(e){
    res.status(500).json({error:e.message});
}
});

//getUserdata if token valid

authRouter.post('/',auth,async (req,res)=>{
    const user=await User.findById(req.user);
    res.json({...user._doc,token:req.token});
});


module.exports=authRouter;