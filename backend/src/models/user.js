import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
  firstName: { type: String, required: true },
  lastName: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  dateOfBirth: { type: Date, required: function() {
    return this.role === "user";
  }},
  role: { type: String, enum: ["user", "admin"], default: "user" },
  phone: { type: String, unique: true, sparse: true },
  // These fields are optional at signup but required for nutrition calculator
  gender: { type: String, enum: ["male", "female"] },
  height: { type: Number },
  weight: { type: Number },
  // Calculated nutrition values
  dailyCalories: { type: Number },
  proteinIntake: { type: Number },
  carbIntake: { type: Number },
  fatIntake: { type: Number },
  // Workout customization fields
  goal: { type: String, enum: ["lose_weight", "gain_muscle", "fitness"] },
  activityLevel: { type: String, enum: ["beginner", "intermediate", "advanced"] },
  gymDaysPerWeek: { type: Number, min: 1, max: 7 },
  sessionDuration: { type: String, enum: ["30-45min", "45-60min", "60-90min"] },
  isActive: { type: Boolean, default: true },
  workoutPlans: {
      type: [{ type: mongoose.Schema.Types.ObjectId, ref: "WorkoutPlan" }],
      default: [],
    },
}, { timestamps: true });

const User = mongoose.model("User", userSchema);
export default User;
