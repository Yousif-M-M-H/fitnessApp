import mongoose from "mongoose";

const workoutPlanSchema = new mongoose.Schema({
  name: String,  
  description: String,
  goal: { type: String, enum: ["lose_weight", "gain_muscle", "fitness"] },
  activityLevel: { type: String, enum: ["beginner", "intermediate", "advanced"] },
  fileUrl: String, 
}, { timestamps: true });

 const WorkoutPlan = mongoose.model("WorkoutPlan", workoutPlanSchema);
export default WorkoutPlan;