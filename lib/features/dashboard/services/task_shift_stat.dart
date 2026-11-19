class TaskShiftStat {
  final String shiftType;
  final int totalTasks;
  final int completedTasks;

  const TaskShiftStat({
    required this.shiftType,
    required this.totalTasks,
    required this.completedTasks,
  });

  double get completionRate {
    if (totalTasks == 0) {
      return 0;
    }

    return completedTasks / totalTasks;
  }
}
