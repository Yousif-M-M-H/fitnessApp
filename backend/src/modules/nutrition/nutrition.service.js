/**
 * Nutrition Calculator Service
 * Calculates daily caloric needs and macronutrient distribution
 */

/**
 * Calculate Basal Metabolic Rate (BMR) using Mifflin-St Jeor Equation
 * @param {number} weight - Weight in kg
 * @param {number} height - Height in cm
 * @param {number} age - Age in years
 * @param {string} gender - "male" or "female"
 * @returns {number} BMR in calories
 */
export const calculateBMR = (weight, height, age, gender) => {
  if (gender === 'male') {
    return 10 * weight + 6.25 * height - 5 * age + 5;
  } else {
    return 10 * weight + 6.25 * height - 5 * age - 161;
  }
};

/**
 * Calculate Total Daily Energy Expenditure (TDEE) based on activity level
 * @param {number} bmr - Basal Metabolic Rate
 * @param {string} activityLevel - Activity level: "sedentary", "light", "moderate", "active", "very_active"
 * @returns {number} TDEE in calories
 */
export const calculateTDEE = (bmr, activityLevel) => {
  const activityMultipliers = {
    sedentary: 1.2,      // Little or no exercise
    light: 1.375,        // Light exercise 1-3 days/week
    moderate: 1.55,      // Moderate exercise 3-5 days/week
    active: 1.725,       // Heavy exercise 6-7 days/week
    very_active: 1.9     // Very heavy exercise, physical job
  };

  const multiplier = activityMultipliers[activityLevel] || 1.2;
  return bmr * multiplier;
};

/**
 * Calculate daily caloric needs based on goal
 * @param {number} tdee - Total Daily Energy Expenditure
 * @param {string} goal - "lose_weight", "gain_muscle", "fitness"
 * @returns {number} Daily calorie target
 */
export const calculateDailyCalories = (tdee, goal) => {
  switch (goal) {
    case 'lose_weight':
      return Math.round(tdee - 500); // 500 calorie deficit for weight loss
    case 'gain_muscle':
      return Math.round(tdee + 300); // 300 calorie surplus for muscle gain
    case 'fitness':
    default:
      return Math.round(tdee); // Maintenance calories
  }
};

/**
 * Calculate macronutrient distribution
 * @param {number} dailyCalories - Daily caloric intake
 * @param {string} goal - "lose_weight", "gain_muscle", "fitness"
 * @returns {object} Protein, carbs, and fat in grams
 */
export const calculateMacros = (dailyCalories, goal) => {
  let proteinPercentage, carbPercentage, fatPercentage;

  switch (goal) {
    case 'lose_weight':
      // High protein, moderate fat, lower carbs
      proteinPercentage = 0.35;  // 35%
      carbPercentage = 0.35;     // 35%
      fatPercentage = 0.30;      // 30%
      break;
    case 'gain_muscle':
      // High protein, high carbs, moderate fat
      proteinPercentage = 0.30;  // 30%
      carbPercentage = 0.45;     // 45%
      fatPercentage = 0.25;      // 25%
      break;
    case 'fitness':
    default:
      // Balanced macros
      proteinPercentage = 0.30;  // 30%
      carbPercentage = 0.40;     // 40%
      fatPercentage = 0.30;      // 30%
      break;
  }

  // Convert percentages to grams
  // Protein: 4 cal/g, Carbs: 4 cal/g, Fat: 9 cal/g
  const proteinGrams = Math.round((dailyCalories * proteinPercentage) / 4);
  const carbGrams = Math.round((dailyCalories * carbPercentage) / 4);
  const fatGrams = Math.round((dailyCalories * fatPercentage) / 9);

  return {
    proteinIntake: proteinGrams,
    carbIntake: carbGrams,
    fatIntake: fatGrams
  };
};

/**
 * Main nutrition calculation function
 * @param {object} params - User parameters
 * @returns {object} Complete nutrition plan
 */
export const calculateNutrition = ({ weight, height, age, gender, activityLevel = 'moderate', goal = 'fitness' }) => {
  // Calculate BMR
  const bmr = calculateBMR(weight, height, age, gender);

  // Calculate TDEE
  const tdee = calculateTDEE(bmr, activityLevel);

  // Calculate daily calories based on goal
  const dailyCalories = calculateDailyCalories(tdee, goal);

  // Calculate macros
  const macros = calculateMacros(dailyCalories, goal);

  return {
    dailyCalories,
    ...macros,
    bmr: Math.round(bmr),
    tdee: Math.round(tdee),
  };
};
