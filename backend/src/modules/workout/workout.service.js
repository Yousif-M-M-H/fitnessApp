/**
 * Workout Plan Generator Service
 * Generates customized workout plans based on user inputs
 */

/**
 * Generate workout plan based on user parameters
 * @param {object} params - User workout preferences
 * @returns {object} Customized workout plan
 */
export const generateWorkoutPlan = ({ gymDaysPerWeek, fitnessLevel, gender, sessionDuration, goal = 'fitness' }) => {

  // Define workout split patterns based on days per week
  const workoutSplits = {
    1: ['Full Body'],
    2: ['Upper Body', 'Lower Body'],
    3: ['Push', 'Pull', 'Legs'],
    4: ['Upper Body', 'Lower Body', 'Upper Body', 'Lower Body'],
    5: ['Push', 'Pull', 'Legs', 'Upper Body', 'Lower Body'],
    6: ['Push', 'Pull', 'Legs', 'Push', 'Pull', 'Legs'],
    7: ['Push', 'Pull', 'Legs', 'Upper Body', 'Lower Body', 'Core/Cardio', 'Active Recovery']
  };

  // Get workout split
  const split = workoutSplits[gymDaysPerWeek] || workoutSplits[3];

  // Define exercises based on workout type and fitness level
  const exerciseDatabase = {
    'Full Body': {
      beginner: [
        'Bodyweight Squats - 3x12',
        'Push-ups (or knee push-ups) - 3x10',
        'Dumbbell Rows - 3x12',
        'Plank - 3x30sec',
        'Lunges - 3x10 each leg'
      ],
      intermediate: [
        'Barbell Squats - 4x8-10',
        'Bench Press - 4x8-10',
        'Barbell Rows - 4x8-10',
        'Overhead Press - 3x10',
        'Romanian Deadlifts - 3x10',
        'Planks - 3x45sec'
      ],
      advanced: [
        'Barbell Squats - 5x5',
        'Bench Press - 5x5',
        'Deadlifts - 4x6',
        'Barbell Rows - 4x8',
        'Overhead Press - 4x6',
        'Pull-ups - 4x8-12',
        'Core Circuit - 4 rounds'
      ]
    },
    'Push': {
      beginner: [
        'Push-ups - 3x10-12',
        'Dumbbell Chest Press - 3x10',
        'Shoulder Press - 3x10',
        'Tricep Dips - 3x8',
        'Lateral Raises - 3x12'
      ],
      intermediate: [
        'Bench Press - 4x8-10',
        'Incline Dumbbell Press - 3x10',
        'Overhead Press - 4x8',
        'Tricep Pushdowns - 3x12',
        'Lateral Raises - 3x12',
        'Cable Flyes - 3x12'
      ],
      advanced: [
        'Bench Press - 5x5',
        'Incline Barbell Press - 4x6-8',
        'Overhead Press - 4x6',
        'Dips - 4x8-12',
        'Close-Grip Bench - 4x8',
        'Lateral Raises - 4x15',
        'Face Pulls - 4x15'
      ]
    },
    'Pull': {
      beginner: [
        'Lat Pulldowns - 3x10',
        'Seated Cable Rows - 3x10',
        'Dumbbell Curls - 3x12',
        'Face Pulls - 3x15',
        'Hammer Curls - 3x12'
      ],
      intermediate: [
        'Pull-ups - 4x6-10',
        'Barbell Rows - 4x8',
        'Lat Pulldowns - 3x10',
        'Dumbbell Rows - 3x10 each',
        'Barbell Curls - 3x10',
        'Hammer Curls - 3x12',
        'Rear Delt Flyes - 3x15'
      ],
      advanced: [
        'Weighted Pull-ups - 5x5',
        'Barbell Rows - 5x5',
        'Deadlifts - 4x6',
        'T-Bar Rows - 4x8',
        'Barbell Curls - 4x8',
        'Preacher Curls - 3x10',
        'Face Pulls - 4x20'
      ]
    },
    'Legs': {
      beginner: [
        'Goblet Squats - 3x12',
        'Leg Press - 3x12',
        'Leg Curls - 3x12',
        'Leg Extensions - 3x12',
        'Calf Raises - 3x15'
      ],
      intermediate: [
        'Barbell Squats - 4x8-10',
        'Romanian Deadlifts - 4x10',
        'Leg Press - 3x12',
        'Leg Curls - 3x12',
        'Bulgarian Split Squats - 3x10 each',
        'Calf Raises - 4x15'
      ],
      advanced: [
        'Barbell Squats - 5x5',
        'Deadlifts - 5x5',
        'Front Squats - 4x6-8',
        'Romanian Deadlifts - 4x8',
        'Bulgarian Split Squats - 4x8 each',
        'Leg Curls - 4x12',
        'Standing Calf Raises - 5x15'
      ]
    },
    'Upper Body': {
      beginner: [
        'Bench Press - 3x10',
        'Dumbbell Rows - 3x10 each',
        'Overhead Press - 3x10',
        'Lat Pulldowns - 3x10',
        'Bicep Curls - 3x12',
        'Tricep Extensions - 3x12'
      ],
      intermediate: [
        'Bench Press - 4x8',
        'Barbell Rows - 4x8',
        'Overhead Press - 4x8',
        'Pull-ups - 3x8-10',
        'Dips - 3x10',
        'Barbell Curls - 3x10',
        'Skull Crushers - 3x10'
      ],
      advanced: [
        'Bench Press - 5x5',
        'Barbell Rows - 5x5',
        'Overhead Press - 4x6',
        'Weighted Pull-ups - 4x6-8',
        'Dips - 4x8-10',
        'Close-Grip Bench - 4x8',
        'Barbell Curls - 4x8'
      ]
    },
    'Lower Body': {
      beginner: [
        'Squats - 3x12',
        'Leg Press - 3x12',
        'Leg Curls - 3x12',
        'Leg Extensions - 3x12',
        'Calf Raises - 3x15'
      ],
      intermediate: [
        'Barbell Squats - 4x8-10',
        'Romanian Deadlifts - 4x10',
        'Leg Press - 3x12',
        'Walking Lunges - 3x12 each',
        'Leg Curls - 3x12',
        'Calf Raises - 4x15'
      ],
      advanced: [
        'Barbell Squats - 5x5',
        'Deadlifts - 5x3',
        'Front Squats - 4x6',
        'Romanian Deadlifts - 4x8',
        'Bulgarian Split Squats - 4x8 each',
        'Calf Raises - 5x15'
      ]
    },
    'Core/Cardio': {
      beginner: [
        'Plank - 3x30sec',
        'Bicycle Crunches - 3x15',
        'Russian Twists - 3x20',
        'Treadmill Walk - 20min',
        'Light Stretching - 10min'
      ],
      intermediate: [
        'Plank - 4x45sec',
        'Hanging Knee Raises - 4x12',
        'Cable Crunches - 4x15',
        'Russian Twists - 4x25',
        'HIIT Cardio - 20min'
      ],
      advanced: [
        'Weighted Planks - 4x60sec',
        'Hanging Leg Raises - 4x15',
        'Ab Wheel Rollouts - 4x12',
        'Cable Woodchoppers - 4x15 each',
        'HIIT Sprints - 25min'
      ]
    },
    'Active Recovery': {
      beginner: ['Light Walk - 30min', 'Stretching - 15min', 'Yoga - 20min'],
      intermediate: ['Light Jog - 30min', 'Yoga - 30min', 'Swimming - 20min'],
      advanced: ['Light Bike - 40min', 'Dynamic Stretching - 20min', 'Mobility Work - 15min']
    }
  };

  // Build the workout plan
  const workoutPlan = split.map((day, index) => {
    const exercises = exerciseDatabase[day]?.[fitnessLevel] || exerciseDatabase['Full Body'][fitnessLevel];

    return {
      day: index + 1,
      type: day,
      duration: sessionDuration,
      exercises: exercises
    };
  });

  // Add cardio recommendations based on goal
  const cardioRecommendations = {
    lose_weight: 'Add 20-30 minutes of moderate cardio after each workout or on rest days',
    gain_muscle: 'Limit cardio to 10-15 minutes of light activity for warm-up',
    fitness: 'Include 15-20 minutes of moderate cardio 2-3 times per week'
  };

  // Rest day recommendations
  const restDayRecommendations = {
    beginner: 'Take 2-3 rest days per week. Focus on light stretching and staying active with walks.',
    intermediate: 'Take 1-2 rest days per week. Consider active recovery like yoga or light cardio.',
    advanced: 'Take 1-2 rest days per week. Include mobility work and foam rolling for recovery.'
  };

  // Nutrition tips based on goal
  const nutritionTips = {
    lose_weight: [
      'Maintain a caloric deficit',
      'Prioritize protein (1g per lb bodyweight)',
      'Stay hydrated (3-4L water/day)',
      'Avoid processed foods and sugary drinks'
    ],
    gain_muscle: [
      'Eat in a slight caloric surplus',
      'Consume 1.2-1.5g protein per lb bodyweight',
      'Time carbs around workouts',
      'Get 7-9 hours of sleep for recovery'
    ],
    fitness: [
      'Maintain balanced caloric intake',
      'Eat adequate protein (0.8-1g per lb)',
      'Include variety of whole foods',
      'Stay consistent with meal timing'
    ]
  };

  // Progressive overload tips based on level
  const progressionTips = {
    beginner: 'Focus on learning proper form. Increase weight by 5-10lbs when you can complete all sets with good form.',
    intermediate: 'Track your weights and aim to increase load or reps each week. Consider deload weeks every 4-6 weeks.',
    advanced: 'Use periodization. Follow a structured program with heavy, medium, and light days. Track all metrics closely.'
  };

  return {
    summary: {
      gymDaysPerWeek,
      fitnessLevel,
      gender,
      sessionDuration,
      goal,
      workoutSplit: split.join(', ')
    },
    weeklyPlan: workoutPlan,
    recommendations: {
      cardio: cardioRecommendations[goal],
      restDays: restDayRecommendations[fitnessLevel],
      nutrition: nutritionTips[goal],
      progression: progressionTips[fitnessLevel]
    },
    generalTips: [
      'Always warm up for 5-10 minutes before training',
      'Focus on progressive overload - increase weight, reps, or volume over time',
      'Rest 2-3 minutes between heavy compound lifts, 60-90 seconds for accessories',
      'Track your workouts to monitor progress',
      'Listen to your body and take extra rest if needed'
    ]
  };
};
