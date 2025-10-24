import Order from "../models/order.js";

 
export const generateUniqueTransactionId = async () => {
    let isUnique = false;
    let transactionId;

    while (!isUnique) {
        transactionId = Math.floor(10000000 + Math.random() * 90000000).toString();  
        const existingOrder = await Order.findOne({ transactionId });
        if (!existingOrder) isUnique = true;  

    return transactionId;
};
};
