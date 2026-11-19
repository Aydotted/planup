import 'burnout_detection_service.dart';
import 'productivity_insight_service.dart';
import 'recommendation_input.dart';

class RecommendationService {
  static List<String> generate({
    required RecommendationInput input,
    required BurnoutResult burnout,
  }) {
    final recommendations = <String>[];

    final insights = ProductivityInsightService.generateInsights(
      taskRates: input.taskRates,
      habitRates: input.habitRates,
    );

    if (input.recoveryTrend == 'Declining') {
      recommendations.add(
        'Recovery trend is declining. Consider scheduling recovery time before fatigue accumulates.',
      );
    }

    if (input.monthlyLoad == 'High') {
      recommendations.add(
        'Monthly workload remains high. Avoid accepting additional commitments this week.',
      );
    }

    if (input.monthlyLoad == 'Chronic') {
      recommendations.add(
        'Workload has remained elevated for an extended period. Prioritise recovery and reduce non-essential workload.',
      );
    }

    if (input.recoveryDebt > 15) {
      recommendations.add(
        'Recovery debt is elevated. Consider scheduling 2–3 recovery days.',
      );
    } else if (input.recoveryDebt > 8) {
      recommendations.add(
        'Recovery load is increasing. Avoid adding unnecessary commitments this week.',
      );
    }

    if (input.taskCompletionRate < 0.6) {
      recommendations.add(
        'Task completion is trending low. Reduce workload during demanding shifts.',
      );
    }

    if (input.habitCompletionRate < 0.6) {
      recommendations.add(
        'Habit consistency is declining. Focus on maintaining key habits before adding new ones.',
      );
    }

    if (burnout.risk == 'High') {
      recommendations.add(
        'Burnout risk is high. Prioritise recovery and reduce workload immediately.',
      );
    } else if (burnout.risk == 'Moderate') {
      recommendations.add(
        'Monitor workload closely and schedule planned recovery time.',
      );
    }

    recommendations.addAll(insights);

    if (recommendations.isEmpty) {
      recommendations.add(
        'Performance indicators are stable. Maintain your current routine.',
      );
    }

    return recommendations;
  }
}
