import 'burnout_input.dart';
import 'burnout_reason.dart';

class BurnoutResult {
  final String risk;
  final String reason;
  final String recommendation;
  final List<BurnoutReason> reasons;

  const BurnoutResult({
    required this.risk,
    required this.reason,
    required this.recommendation,
    required this.reasons,
  });
}

class BurnoutDetectionService {
  static BurnoutResult evaluate({required BurnoutInput input}) {
    final reasons = <BurnoutReason>[];

    int score = 0;

    if (input.recoveryDebt > 30) {
      score += 5;

      reasons.add(
        const BurnoutReason(
          title: 'Critical Recovery Load',
          description: 'Recovery debt has reached a critical level.',
        ),
      );
    } else if (input.recoveryDebt > 20) {
      score += 4;

      reasons.add(
        const BurnoutReason(
          title: 'Recovery Load',
          description: 'Recent debt is critically elevated.',
        ),
      );
    } else if (input.recoveryDebt > 12) {
      score += 3;

      reasons.add(
        const BurnoutReason(
          title: 'Recovery Load',
          description: 'Recent shift workload is elevated.',
        ),
      );
    }

    if (input.recoveryTrend == 'Declining') {
      score += 2;

      reasons.add(
        const BurnoutReason(
          title: 'Recovery Trend',
          description: 'Recovery has worsened compared to the previous week.',
        ),
      );
    }

    if (input.monthlyLoad == 'High') {
      score += 2;

      reasons.add(
        const BurnoutReason(
          title: 'Monthly Load',
          description: 'Workload has remained high over the last month.',
        ),
      );
    }

    if (input.monthlyLoad == 'Chronic') {
      score += 3;

      reasons.add(
        const BurnoutReason(
          title: 'Monthly Load',
          description: 'Workload has remained elevated for an extended period.',
        ),
      );
    }

    if (input.taskCompletionRate < 0.5) {
      score += 3;

      reasons.add(
        const BurnoutReason(
          title: 'Task Performance',
          description: 'Task completion has dropped significantly.',
        ),
      );
    } else if (input.taskCompletionRate < 0.7) {
      score += 1;

      reasons.add(
        const BurnoutReason(
          title: 'Task Performance',
          description: 'Task completion is below normal levels.',
        ),
      );
    }

    if (input.habitCompletionRate < 0.5) {
      score += 3;

      reasons.add(
        const BurnoutReason(
          title: 'Habit Consistency',
          description: 'Habit consistency has dropped significantly.',
        ),
      );
    } else if (input.habitCompletionRate < 0.7) {
      score += 1;

      reasons.add(
        const BurnoutReason(
          title: 'Habit Consistency',
          description: 'Habit consistency is below expected levels.',
        ),
      );
    }

    if (score >= 12) {
      return BurnoutResult(
        risk: 'High',
        reason: 'High workload, declining recovery trends and reduced productivity indicators have been detected.',
        recommendation:
            'Strongly consider taking recovery time and reducing workload.',
        reasons: reasons,
      );
    }

    if (score >= 5) {
      return BurnoutResult(
        risk: 'Moderate',
        reason: 'Early signs of fatigue and reduced consistency have been detected.',
        recommendation:
            'Schedule recovery time and avoid adding extra commitments.',
        reasons: reasons,
      );
    }

    return BurnoutResult(
      risk: 'Low',
      reason: 'Current recovery and productivity indicators appear stable.',
      recommendation: 'Maintain current workload and recovery habits.',
      reasons: reasons,
    );
  }

  static double habitCompletionRate({
    required int totalHabits,
    required int completedToday,
  }) {
    if (totalHabits == 0) {
      return 1.0;
    }

    return completedToday / totalHabits;
  }
}
