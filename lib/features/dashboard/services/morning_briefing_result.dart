class MorningBriefingResult {
  final String shift;

  final String recoveryStatus;

  final String burnoutRisk;

  final int dueToday;

  final int overdue;

  final int expectedProductivity;

  final String focus;

  final String recoveryRecommendation;

  final bool highBurnoutRisk;

  final bool hasOverdueTasks;

  const MorningBriefingResult({
    required this.shift,
    required this.recoveryStatus,
    required this.burnoutRisk,
    required this.dueToday,
    required this.overdue,
    required this.expectedProductivity,
    required this.focus,
    required this.recoveryRecommendation,
    required this.highBurnoutRisk,
    required this.hasOverdueTasks,
  });
}
