import mongoose from "mongoose";
import Product from "../models/product.model.js";

export const getProducts = async(req,res)=>{
    try {
        const products = await Product.find({});
        res.status(200).json({success: true, data: products});
    } catch (error) {
        console.log("error in fetching products", error.message);
        res.status(500).json({success: false, message:"Server error"})
    }
}

export const postProducts = async (req,res)=>{
    const product = req.body;

    if(!product.name || !product.price || !product.image){
        return res.status(400).json({success:false, msg:"please provide all fields"});
    }

    const newProduct = Product(product)

    try {
        await newProduct.save();
        res.status(201).json({success: true,data: newProduct});
    } catch (error) {
        console.error("Error in Create product:", error.message);
        res.status(500).json({success: false, message: "Server Error"});
    }
}


export const putProducts = async(req,res)=>{
    const { id } = req.params;
    const product = req.body;

    if(!mongoose.Types.ObjectId.isValid(id)){
        return res.status(404).json({success:false, msg:"Invalid product id"});
    }
    try {
        const updatedProduct = await Product.findByIdAndUpdate(id, product, {new: true});
        res.status(200).json({success: true, data: updatedProduct});
    } catch (error) {
        res.status(500).json({success: false, message: "Server Error"});
    }
}

export const deleteProduct = async(req,res)=>{
    const {id} =req.params;

    if(!mongoose.Types.ObjectId.isValid(id)){
        return res.status(404).json({success:false, msg:"Invalid product id"});
    }

    try {
        await Product.findByIdAndDelete(id);
        res.status(200).json({success: true, message:"Product deleted"});
    } catch (error) {
        console.log("Error while deleting the products: ", error.message);
        res.status(500).json({success:false,msg:"Server Error"});
    }
}