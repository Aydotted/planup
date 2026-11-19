import 'package:flutter/material.dart';

import 'morning_briefing_result.dart';
import '../../dashboard/services/top_productive_shift_service.dart';

class MorningBriefingService {
  static MorningBriefingResult generate({
    required String shift,
    required String recoveryStatus,
    required String burnoutRisk,
    required int dueToday,
    required int overdue,
    required double forecastCompletion,
  }) {
    String focus;

    if (burnoutRisk == 'High') {
      focus = 'Keep workload light and prioritise recovery.';
    } else if (overdue > 0) {
      focus = 'Address overdue tasks before taking on new work.';
    } else if (forecastCompletion < 0.6) {
      focus = 'Focus only on high-priority tasks today.';
    } else {
      focus = 'Maintain momentum and complete key priorities early.';
    }

    String recoveryRecommendation;

    if (burnoutRisk == 'High') {
      recoveryRecommendation = 'Take recovery time and reduce workload';
    } else if (recoveryStatus == 'High' || recoveryStatus == 'Elevated') {
      recoveryRecommendation = 'schedule at least 1-2 recovery days.';
    } else if (recoveryStatus == 'Moderate') {
      recoveryRecommendation = 'Avoid unnecessary commitments this week.';
    } else {
      recoveryRecommendation = 'Maintain current recovery habits.';
    }

    return MorningBriefingResult(
      shift: shift,
      recoveryStatus: recoveryStatus,
      burnoutRisk: burnoutRisk,
      dueToday: dueToday,
      overdue: overdue,
      expectedProductivity: (forecastCompletion * 100).round(),
      focus: focus,
      recoveryRecommendation: recoveryRecommendation,
      highBurnoutRisk: burnoutRisk == 'High',
      hasOverdueTasks: overdue > 0,
    );
  }
}
