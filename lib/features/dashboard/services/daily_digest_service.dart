import 'daily_digest_result.dart';

class DailyDigestService {
  static DailyDigestResult generate({
    required String shift,
    required String recoveryStatus,
    required String burnoutRisk,
    required int tasksDueToday,
    required int overdueTasks,
    required int expectedProductivity,
  }) {
    String keyInsight;

    if (burnoutRisk == 'High') {
      keyInsight = 'Burnout risk is elevated.';
    } else if (recoveryStatus != 'Recovered') {
      keyInsight = 'Recovery should be prioritised.';
    } else {
      keyInsight = 'Performance indicators are stable.';
    }

    String focus;

    if (overdueTasks > 0) {
      focus = 'Clear overdue tasks first.';
    } else if (expectedProductivity < 60) {
      focus = 'Keep workload light and focus on high-impact work.';
    } else {
      focus = 'Maintain momentum and complete priorities early.';
    }

    return DailyDigestResult(
      shift: shift,
      recoveryStatus: recoveryStatus,
      burnoutRisk: burnoutRisk,
      tasksDueToday: tasksDueToday,
      overdueTasks: overdueTasks,
      expectedProductivity: expectedProductivity,
      keyInsight: keyInsight,
      focus: focus,
    );
  }
}
