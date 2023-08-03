import random

def normalize_weights(weights):
    total_weight = sum(weights)
    return [w / total_weight for w in weights]

def create_schedule():
    return {
        'Monday': [0 for _ in range(24)],
        'Tuesday': [0 for _ in range(24)],
        'Wednesday': [0 for _ in range(24)],
        'Thursday': [0 for _ in range(24)],
        'Friday': [0 for _ in range(24)],
        'Saturday': [0 for _ in range(24)],
    }

def select_course(courses, normalized_weights):
    return random.choices(courses, weights=normalized_weights)[0]

def find_available_slots(day_schedule, available_slots):
    return [i for i in range(24) if day_schedule[i] == 0 and i in available_slots]

def distribute_courses(courses, weights, available_time):
    # Normalize weights
    normalized_weights = normalize_weights(weights)

    # Create a dictionary to represent the weekly schedule
    schedule = create_schedule()

    # Distribute courses over the available time slots
    for day in schedule:
        daily_available_time = random.choice(available_time[day]) if available_time[day] else 0
        for _ in range(daily_available_time):
            # Select a course based on their normalized weights
            selected_course = select_course(courses, normalized_weights)

            # Find a random available time slot in the day
            available_slots = find_available_slots(schedule[day], available_time[day])
            if available_slots:
                hour = random.choice(available_slots)
                schedule[day][hour] = selected_course

    # Calculate the total hours each course got
    course_hours = {course: sum(course == schedule[day][hour] for day in schedule for hour in range(24)) for course in courses}

    # Return the weekly schedule and total hours for each course
    return schedule, course_hours

def allocate_courses_for_day(courses, weights, available_slots):
    # Normalize weights
    normalized_weights = normalize_weights(weights)

    # Create a schedule for the day
    schedule = [0 for _ in range(24)]

    # Distribute courses over the available time slots
    daily_available_time = available_slots if available_slots else 0
    for _ in range(daily_available_time):
        # Select a course based on their normalized weights
        selected_course = select_course(courses, normalized_weights)

        # Find a random available time slot in the day
        available_slots = find_available_slots(schedule, available_slots)
        if available_slots:
            hour = random.choice(available_slots)
            schedule[hour] = selected_course

    # Calculate the total hours each course got
    course_hours = {course: schedule.count(course) for course in set(courses)}

    # Return the schedule and total hours for each course
    return schedule, course_hours
