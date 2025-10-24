import multer from "multer";
import { v4 as uuidv4 } from "uuid";
import { AppError } from "../utils/error/error.js";

const fileUpload = () => {
  const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, "uploads/");
    },
    filename: (req, file, cb) => {
      if (file) {
        cb(null, uuidv4() + "_" + file.originalname);
      } else {
        cb(null, false);
      }
    },
  });


  const allowedMimeTypes = [
    "application/vnd.ms-excel", // .xls
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", // .xlsx
  ];

  const fileFilter = (req, file, cb) => {
    if (!allowedMimeTypes.includes(file.mimetype)) {
      return cb(new AppError("Only Excel files are allowed (.xls, .xlsx)", 400), false);
    }
    cb(null, true);
  };

  return multer({
    storage,
    fileFilter,
    limits: { fileSize: 1024 * 1024 * 10 }, // 10 MB
  });
};

export const uploadSingleFile = (fieldName) => fileUpload().single(fieldName);
export const uploadArrayFile = (fieldName) => fileUpload().array(fieldName, 10);
export const uploadFields = (fields) => fileUpload().fields(fields);
