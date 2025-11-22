/**
 * Workout Plan Generator Service
 * Generates customized workout plans based on user inputs
 */

/**
 * Exercise descriptions database
 * Maps exercise names to their detailed descriptions
 */
const exerciseDescriptions = {
  // Squats
  'Bodyweight Squats': 'Stand with feet shoulder-width apart. Lower your body by bending knees and pushing hips back as if sitting in a chair. Keep chest up and weight on heels. Push through heels to return to starting position.',
  'Goblet Squats': 'Hold a dumbbell or kettlebell at chest level. Squat down keeping your chest up and elbows between your knees. Push through heels to stand.',
  'Barbell Squats': 'Place barbell on upper back. Stand with feet shoulder-width apart. Lower by bending knees while keeping chest up. Drive through heels to return.',
  'Front Squats': 'Rest barbell on front shoulders. Keep elbows high and chest up. Squat down maintaining upright torso. Drive through heels to stand.',
  'Squats': 'Classic lower body exercise. Lower your hips from standing position then stand back up. Keep core tight and back straight throughout the movement.',

  // Pressing movements
  'Push-ups': 'Start in plank position with hands shoulder-width apart. Lower chest to ground keeping body straight. Push back up to starting position.',
  'Knee Push-ups': 'Same as push-ups but with knees on ground. Great for building upper body strength for beginners.',
  'Bench Press': 'Lie on bench, grip barbell slightly wider than shoulders. Lower bar to chest, then press up powerfully. Keep feet planted and back slightly arched.',
  'Incline Dumbbell Press': 'Set bench to 30-45 degrees. Press dumbbells up from chest level. Control the descent and maintain steady tempo.',
  'Incline Barbell Press': 'Inclined bench press targeting upper chest. Press barbell from upper chest to full extension.',
  'Dumbbell Chest Press': 'Lie on bench with dumbbells. Press weights up until arms are extended, then lower with control.',
  'Overhead Press': 'Press barbell or dumbbells overhead from shoulder level. Keep core tight and avoid leaning back.',
  'Shoulder Press': 'Seated or standing press with dumbbells from shoulders to overhead. Maintain neutral spine.',

  // Pulling movements
  'Dumbbell Rows': 'Bend at hips with dumbbell in hand. Pull weight to hip while squeezing shoulder blade. Lower with control.',
  'Barbell Rows': 'Hinge at hips holding barbell. Pull bar to lower chest/upper abs while keeping back straight.',
  'Seated Cable Rows': 'Sit at cable machine. Pull handle to torso while keeping back straight. Squeeze shoulder blades together.',
  'T-Bar Rows': 'Straddle T-bar, hinge at hips. Pull weight to chest while maintaining straight back.',
  'Pull-ups': 'Hang from bar with overhand grip. Pull yourself up until chin clears bar. Lower with control.',
  'Weighted Pull-ups': 'Pull-ups with added weight via belt or weighted vest for advanced strength building.',
  'Lat Pulldowns': 'Sit at lat pulldown machine. Pull bar down to upper chest while keeping torso upright.',

  // Deadlifts
  'Deadlifts': 'Stand with feet under barbell. Grip bar, keep back straight, drive through legs and hips to stand. Lower with control.',
  'Romanian Deadlifts': 'Hold barbell at hips. Hinge forward keeping legs nearly straight. Feel hamstring stretch, then return to standing.',

  // Lunges
  'Lunges': 'Step forward into lunge position. Lower back knee toward ground. Push through front heel to return.',
  'Walking Lunges': 'Perform lunges while walking forward. Alternate legs with each step.',
  'Bulgarian Split Squats': 'Place rear foot on bench. Lower into single leg squat. Press through front heel to stand.',

  // Triceps
  'Tricep Dips': 'Using parallel bars or bench, lower body by bending elbows. Press back up to starting position.',
  'Tricep Pushdowns': 'At cable machine, push rope or bar down by extending elbows. Keep upper arms stationary.',
  'Tricep Extensions': 'Extend arms overhead or behind head with weight. Focus on elbow movement only.',
  'Skull Crushers': 'Lying down, lower weight toward forehead by bending elbows. Extend arms to return.',
  'Close-Grip Bench': 'Bench press with narrow grip to emphasize triceps. Keep elbows closer to body.',

  // Biceps
  'Dumbbell Curls': 'Stand with dumbbells at sides. Curl weights up by bending elbows. Lower with control.',
  'Barbell Curls': 'Grip barbell with underhand grip. Curl weight up while keeping elbows stationary.',
  'Hammer Curls': 'Hold dumbbells with neutral grip (palms facing each other). Curl up maintaining grip position.',
  'Preacher Curls': 'Rest upper arms on preacher bench. Curl weight up focusing on bicep contraction.',
  'Bicep Curls': 'Classic bicep curl with dumbbells or barbell. Focus on controlled movement and full range.',

  // Shoulders
  'Lateral Raises': 'Hold dumbbells at sides. Raise arms out to sides until parallel with ground. Lower slowly.',
  'Face Pulls': 'Pull rope attachment toward face at cable machine. Focus on rear delts and upper back.',
  'Rear Delt Flyes': 'Bent over or on incline bench, raise dumbbells out to sides targeting rear shoulders.',
  'Cable Flyes': 'Using cable machine at chest height, bring handles together in front of chest.',

  // Legs
  'Leg Press': 'Seated at leg press machine. Push platform away by extending legs. Lower with control.',
  'Leg Curls': 'Lying or seated, curl legs by bending knees against resistance.',
  'Leg Extensions': 'Seated, extend legs by straightening knees against resistance pad.',
  'Calf Raises': 'Stand on edge of platform. Raise up onto toes, then lower heels below platform level.',
  'Standing Calf Raises': 'Standing calf raises with barbell or machine. Full range of motion for calf development.',

  // Core
  'Plank': 'Hold push-up position on forearms. Keep body straight from head to heels. Engage core throughout.',
  'Bicycle Crunches': 'Lying on back, alternate bringing elbow to opposite knee in cycling motion.',
  'Russian Twists': 'Seated with feet elevated, twist torso side to side while holding weight.',
  'Hanging Knee Raises': 'Hang from bar, raise knees toward chest by contracting abs.',
  'Hanging Leg Raises': 'Hang from bar with straight legs, raise feet toward bar using abs.',
  'Cable Crunches': 'Kneeling at cable machine, crunch down by contracting abs against resistance.',
  'Ab Wheel Rollouts': 'On knees with ab wheel, roll forward extending body, then pull back using core.',
  'Cable Woodchoppers': 'Rotate torso pulling cable from high to low position diagonally across body.',
  'Weighted Planks': 'Standard plank with weight plate on back for increased difficulty.',
  'Core Circuit': 'Series of core exercises performed back-to-back with minimal rest.',

  // Compound movements
  'Dips': 'Support yourself on parallel bars. Lower body by bending elbows, then press back up.',

  // Cardio & Recovery
  'Treadmill Walk': 'Walk at moderate pace on treadmill. Maintain steady breathing and posture.',
  'Light Walk': 'Easy-paced walk outdoors or indoors for active recovery.',
  'Light Jog': 'Slow, comfortable jogging pace for cardiovascular health and recovery.',
  'Light Bike': 'Low-intensity cycling for active recovery and mobility.',
  'Light Stretching': 'Gentle stretching routine to improve flexibility and reduce muscle tension.',
  'Dynamic Stretching': 'Active stretching with movement to improve mobility and warm up muscles.',
  'Yoga': 'Yoga practice focusing on flexibility, balance, and mindful movement.',
  'Swimming': 'Low-impact swimming for full-body conditioning and recovery.',
  'Mobility Work': 'Exercises focused on improving joint range of motion and movement quality.',
  'HIIT Cardio': 'High-Intensity Interval Training alternating between intense bursts and recovery periods.',
  'HIIT Sprints': 'Short, maximum effort sprints followed by rest periods.',
};

/**
 * Get exercise description
 * @param {string} exerciseName - Name of the exercise
 * @returns {string} Description of the exercise
 */
const getExerciseDescription = (exerciseName) => {
  return exerciseDescriptions[exerciseName] || 'Perform this exercise with proper form and controlled movements.';
};

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

  // Build the workout plan with exercise descriptions
  const workoutPlan = split.map((day, index) => {
    const exerciseStrings = exerciseDatabase[day]?.[fitnessLevel] || exerciseDatabase['Full Body'][fitnessLevel];

    // Transform each exercise string to include description
    const exercisesWithDescriptions = exerciseStrings.map(exerciseStr => {
      // Extract exercise name (before the ' - ')
      const exerciseName = exerciseStr.split(' - ')[0].trim();
      const description = getExerciseDescription(exerciseName);

      return {
        exercise: exerciseStr,
        description: description
      };
    });

    return {
      day: index + 1,
      type: day,
      duration: sessionDuration,
      exercises: exercisesWithDescriptions
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
