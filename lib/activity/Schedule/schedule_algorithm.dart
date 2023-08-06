import 'dart:math';

class CourseScheduler {
  Map<String, List<int>> selectedHours;

  CourseScheduler({required this.selectedHours});

  List<double> normalizeWeights(List<double> weights) {
    double totalWeight = weights.reduce((a, b) => a + b);
    return weights.map((w) => w / totalWeight).toList();
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

  Map<String, dynamic> distributeCourses() {
    List<String> courseNames = [
      'Course_A',
      'Course_B',
      'Course_C',
      'Course_D',
      'Course_E',
      'Course_F'
    ];
    List<double> weights = [3, 3, 4, 2, 3, 2];

    // Normalize weights
    List<double> normalizedWeights = normalizeWeights(weights);

    // Create a dictionary to represent the weekly schedule
    Map<String, List<String>> schedule = {};

    // Distribute courses over the available time slots
    for (String day in selectedHours.keys) {
      int dailyAvailableTime = selectedHours[day]?.length ?? 0;
      schedule[day] = [];
      for (int _ = 0; _ < dailyAvailableTime; _++) {
        // Select a course based on their normalized weights
        int selectedCourseIndex = selectCourse(
            List.generate(courseNames.length, (index) => index),
            normalizedWeights);
        String selectedCourse = courseNames[selectedCourseIndex];

        // Find a random available time slot in the day
        List<int> availableSlots = selectedHours[day]!;
        if (availableSlots.isNotEmpty) {
          int hour = availableSlots[Random().nextInt(availableSlots.length)];
          schedule[day]!.add(selectedCourse);
        }
      }
    }

    // Return the weekly schedule with course names
    return schedule;
  }
}
