class FocusRecommendationEngine {
  static String generateRecommendation({
    required String? shiftType,
    required int overdueTasks,
    required int dueToday,
    required double completionRate,
  }) {
    if (overdueTasks >= 5) {
      return 'You have $overdueTasks overdue tasks. Focus on clearing overdue work before taking on new commitments.';
    }

    if (overdueTasks > 0) {
      return 'You have $overdueTasks overdue tasks. Prioritise overdue items first today.';
    }

    switch (shiftType) {
      case 'Night':
        return 'Night Shift scheduled today. Complete important tasks before 18:00 while energy and focus are highest.';

      case 'Long Day':
        return 'Long Day scheduled. Focus on high-impact tasks early and keep workload realistic.';

      case 'Twilight':
        return 'Twilight Shift scheduled. Use the morning to clear important personal and administrative tasks.';

      case 'Training':
        return 'Training Day scheduled. Good opportunity to complete learning goals and lower-priority admin work.';

      case 'Annual Leave':
        return 'Annual Leave today. Consider disconnecting and avoiding non-essential tasks.';

      case 'Off':
        return 'Off Day. Great opportunity to clear personal goals, overdue items, or prepare for upcoming shifts.';

      default:
        break;
    }

    if (dueToday >= 5) {
      return 'You have $dueToday tasks due today. Focus on completing your highest-priority items first.';
    }

    if (dueToday > 0) {
      return 'You have $dueToday tasks due today. Aim to complete them before adding new work.';
    }

    if (completionRate < 0.4) {
      return 'Weekly completion is below 40%. Focus on completing existing tasks before creating new ones.';
    }

    if (completionRate > 0.8) {
      return 'Excellent progress this week. Consider planning ahead for upcoming priorities.';
    }

    return 'You are on track. Focus on your most important task and maintain momentum.';
  }

  static String workloadLevel({
    required int overdueTasks,
    required int dueToday,
  }) {
    final score = overdueTasks * 2 + dueToday;

    if (score >= 10) {
      return 'High';
    }

    if (score >= 5) {
      return 'Medium';
    }

    return 'Low';
  }

  static String productivityStatus(double completionRate) {
    if (completionRate >= 0.9) {
      return 'Excellent';
    }

    if (completionRate >= 0.7) {
      return 'Good';
    }

    if (completionRate >= 0.5) {
      return 'Fair';
    }

    return 'Needs Attention';
  }

  static String priorityLevel({
    required int overdueTasks,
    required int dueToday,
  }) {
    if (overdueTasks > 0) {
      return 'High';
    }

    if (dueToday >= 3) {
      return 'Medium';
    }

    return 'Low';
  }

  static String bestAction({
    required String? shiftType,
    required int overdueTasks,
    required int dueToday,
  }) {
    if (overdueTasks > 0) {
      return 'Clear overdue tasks first';
    }

    if (shiftType == 'Night') {
      return 'Finish focused work before 18:00';
    }

    if (shiftType == 'Training') {
      return 'Use spare time for admin tasks';
    }

    if (shiftType == 'Off') {
      return 'Ideal day for personal goals';
    }

    return 'Focus on your highest priority task';
  }

  static int focusScore({required int overdueTasks, required int dueToday}) {
    return (overdueTasks * 3) + dueToday;
  }
}
