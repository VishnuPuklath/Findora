
//import from other packages
const express=require('express');
const mongoose=require('mongoose');

//Import from other files
const authRouter=require("./routes/auth.js");
const adminRouter = require('./routes/admin.js');
const productRouter = require('./routes/product.js');
const userRouter = require('./routes/user.js');

//init
const PORT=3000;
const app=express();

const DB="mongodb+srv://vishnu:vishnu%40mongoose@cluster0.qdvq8.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";
//middleware
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

//connections
 mongoose.connect(DB).then(()=>{
    console.log('mongoose connected')
 }).catch(e=>{
    console.log(e);
 });

//listening to port
app.listen(PORT,"0.0.0.0",()=>{
    console.log(`Good news Connected at PORT ${PORT}`);
});

