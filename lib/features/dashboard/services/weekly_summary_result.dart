class WeeklySummaryResult {
  final int tasksCompleted;

  final int totalTasks;

  final double completionRate;

  final String recoveryTrend;

  final String burnoutRisk;

  final String monthlyLoad;

  final String focus;

  const WeeklySummaryResult({
    required this.tasksCompleted,
    required this.totalTasks,
    required this.completionRate,
    required this.recoveryTrend,
    required this.burnoutRisk,
    required this.monthlyLoad,
    required this.focus,
  });
}
