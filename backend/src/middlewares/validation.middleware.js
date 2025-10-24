import { AppError } from "../utils/error/error.js";

const validate = schema => {
  return (req, res, next) => {
    const { error } = schema.validate(
      { ...req.body, ...req.params, ...req.query },
      { abortEarly: false }
    );

    if (error) {
      const { details } = error;
      const messages = details.map(i => i.message.replace(/["/]/g, ''));
      next(new AppError(messages.join(', '), 403));
    } else {
      next();
    }
  };
};

export default validate;
