import 'dart:math';

class CourseScheduler {
  List<double> normalizeWeights(List<double> weights) {
    double totalWeight = weights.reduce((a, b) => a + b);
    return weights.map((w) => w / totalWeight).toList();
  }

  Map<String, List<int>> createSchedule() {
    return {
      'Monday': List<int>.filled(24, 0),
      'Tuesday': List<int>.filled(24, 0),
      'Wednesday': List<int>.filled(24, 0),
      'Thursday': List<int>.filled(24, 0),
      'Friday': List<int>.filled(24, 0),
      'Saturday': List<int>.filled(24, 0),
    };
  }

  int selectCourse(List<int> courses, List<double> normalizedWeights) {
    double randomValue = Random().nextDouble();
    double cumulativeWeight = 0;

    for (int i = 0; i < courses.length; i++) {
      cumulativeWeight += normalizedWeights[i];
      if (randomValue < cumulativeWeight) {
        return courses[i];
      }
    }

    return 0; // This should not be reached, but to satisfy the compiler.
  }

  List<int> findAvailableSlots(
      List<int> daySchedule, List<int> availableSlots) {
    return availableSlots.where((slot) => daySchedule[slot] == 0).toList();
  }

  Map<String, dynamic> distributeCourses() {
    List<int> courses = [1, 2, 3, 4, 5, 6];
    List<double> weights = [3, 3, 4, 2, 3, 2];

    // Normalize weights
    List<double> normalizedWeights = normalizeWeights(weights);

    // Create a dictionary to represent the weekly schedule
    Map<String, List<int>> schedule = createSchedule();

    // Distribute courses over the available time slots
    for (String day in schedule.keys) {
      int dailyAvailableTime =
          Random().nextInt(11); // Randomly allocate up to 10 hours per day
      for (int _ = 0; _ < dailyAvailableTime; _++) {
        // Select a course based on their normalized weights
        int selectedCourse = selectCourse(courses, normalizedWeights);

        // Find a random available time slot in the day
        List<int> availableSlots = findAvailableSlots(
            schedule[day]!, List.generate(11, (index) => index + 8));
        if (availableSlots.isNotEmpty) {
          int hour = availableSlots[Random().nextInt(availableSlots.length)];
          schedule[day]![hour] = selectedCourse;
        }
      }
    }

    // Calculate the total hours each course got
    Map<int, int> courseHours = {};
    for (int course in courses) {
      int totalHours = 0;
      for (String day in schedule.keys) {
        for (int hour in schedule[day]!) {
          if (hour == course) {
            totalHours++;
          }
        }
      }
      courseHours[course] = totalHours;
    }

    // Return the weekly schedule and total hours for each course
    return {
      'schedule': schedule,
      'course_hours': courseHours,
    };
  }

  Map<String, dynamic> allocateCoursesForDay() {
    List<int> courses = [1, 2, 3, 4, 5, 6];
    List<double> weights = [3, 3, 4, 2, 3, 2];

    // Normalize weights
    List<double> normalizedWeights = normalizeWeights(weights);

    // Create a schedule for the day
    List<int> schedule = List<int>.filled(24, 0);

    // Distribute courses over the available time slots
    int dailyAvailableTime =
        Random().nextInt(11); // Randomly allocate up to 10 hours per day
    for (int _ = 0; _ < dailyAvailableTime; _++) {
      // Select a course based on their normalized weights
      int selectedCourse = selectCourse(courses, normalizedWeights);

      // Find a random available time slot in the day
      List<int> availableSlots =
          findAvailableSlots(schedule, List.generate(11, (index) => index + 8));
      if (availableSlots.isNotEmpty) {
        int hour = availableSlots[Random().nextInt(availableSlots.length)];
        schedule[hour] = selectedCourse;
      }
    }

    // Calculate the total hours each course got
    Map<int, int> courseHours = {};
    for (int course in courses) {
      courseHours[course] = schedule.where((hour) => hour == course).length;
    }

    // Return the schedule and total hours for each course
    return {
      'schedule': schedule,
      'course_hours': courseHours,
    };
  }
}

void main() {
  CourseScheduler scheduler = CourseScheduler();

  // Generate a weekly schedule
  Map<String, dynamic> weeklySchedule = scheduler.distributeCourses();
  print("Weekly Schedule:");
  print(weeklySchedule['schedule']);
  print("Course Hours:");
  print(weeklySchedule['course_hours']);

  // Generate a daily schedule
  Map<String, dynamic> dailySchedule = scheduler.allocateCoursesForDay();
  print("\nDaily Schedule:");
  print(dailySchedule['schedule']);
  print("Course Hours:");
  print(dailySchedule['course_hours']);
}
