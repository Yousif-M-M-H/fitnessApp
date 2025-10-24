export const asyncHandler= (fn)=>{
    return (req,res,next)=>{
        fn(req,res,next).catch((error)=>next(error))
    }
}

export class AppError extends Error {
    constructor(message, statusCode, statusMessage = "failed") {
      super(message);
      this.statusCode = statusCode;
      this.statusMessage = statusMessage;
  
      if (Error.captureStackTrace) {
        Error.captureStackTrace(this, this.constructor);
      }
    }
  }
