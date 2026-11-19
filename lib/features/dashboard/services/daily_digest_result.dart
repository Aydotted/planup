class DailyDigestResult {
  final String shift;
  final String recoveryStatus;
  final String burnoutRisk;

  final int tasksDueToday;
  final int overdueTasks;

  final int expectedProductivity;

  final String keyInsight;
  final String focus;

  const DailyDigestResult({
    required this.shift,
    required this.recoveryStatus,
    required this.burnoutRisk,
    required this.tasksDueToday,
    required this.overdueTasks,
    required this.expectedProductivity,
    required this.keyInsight,
    required this.focus,
  });
}
