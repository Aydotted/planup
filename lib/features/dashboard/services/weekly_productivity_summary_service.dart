import 'weekly_summary_result.dart';

class WeeklyProductivitySummaryService {
  static WeeklySummaryResult analyse({
    required int completedTasks,
    required int totalTasks,
    required String recoveryTrend,
    required String burnoutRisk,
    required String monthlyLoad,
  }) {
    final completionRate = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

    String focus;

    if (burnoutRisk == 'High') {
      focus = 'Prioritise recovery and reduce workload.';
    } else if (recoveryTrend == 'Declining') {
      focus = 'Schedule recovery before fatigue accumulates.';
    } else {
      focus = 'Maintain current recovery habits.';
    }

    return WeeklySummaryResult(
      tasksCompleted: completedTasks,
      totalTasks: totalTasks,
      completionRate: completionRate,
      recoveryTrend: recoveryTrend,
      burnoutRisk: burnoutRisk,
      monthlyLoad: monthlyLoad,
      focus: focus,
    );
  }
}
