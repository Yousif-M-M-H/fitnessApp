import mongoose from "mongoose";

const exerciseSchema = new mongoose.Schema({
  exercise: String,
  description: String
}, { _id: false });

const dayWorkoutSchema = new mongoose.Schema({
  day: Number,
  type: String,
  duration: String,
  exercises: [exerciseSchema]
}, { _id: false });

const recommendationsSchema = new mongoose.Schema({
  cardio: String,
  restDays: String,
  nutrition: [String],
  progression: String
}, { _id: false });

const userWorkoutSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true
  },
  userName: String,

  // Summary
  gymDaysPerWeek: Number,
  fitnessLevel: String,
  gender: String,
  sessionDuration: String,
  goal: String,
  workoutSplit: String,

  // Full workout plan data
  weeklyPlan: [dayWorkoutSchema],

  recommendations: recommendationsSchema,

  generalTips: [String]
}, { timestamps: true });

const UserWorkout = mongoose.model("UserWorkout", userWorkoutSchema);
export default UserWorkout;