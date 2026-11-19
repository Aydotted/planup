import '../../shifts/domain/entities/shift.dart';

import 'recovery_score_service.dart';
import 'recovery_trend_result.dart';

class RecoveryTrendService {
  static RecoveryTrendResult analyse(List<Shift> shifts) {
    final now = DateTime.now();

    final currentWeek = shifts
        .where(
          (shift) => shift.date.isAfter(now.subtract(const Duration(days: 7))),
        )
        .toList();

    final previousWeek = shifts
        .where(
          (shift) =>
              shift.date.isAfter(now.subtract(const Duration(days: 14))) &&
              shift.date.isBefore(now.subtract(const Duration(days: 7))),
        )
        .toList();

    final month = shifts
        .where(
          (shift) => shift.date.isAfter(now.subtract(const Duration(days: 28))),
        )
        .toList();

    final currentDebt = RecoveryScoreService.calculateRecoveryDebt(currentWeek);

    final previousDebt = RecoveryScoreService.calculateRecoveryDebt(
      previousWeek,
    );

    final monthlyDebt = RecoveryScoreService.calculateRecoveryDebt(month);

    String trend;

    if (currentDebt < previousDebt) {
      trend = 'Improving';
    } else if (currentDebt > previousDebt) {
      trend = 'Declining';
    } else {
      trend = 'Stable';
    }

    String monthlyLoad;

    if (monthlyDebt <= 15) {
      monthlyLoad = 'Low';
    } else if (monthlyDebt <= 35) {
      monthlyLoad = 'Moderate';
    } else if (monthlyDebt <= 55) {
      monthlyLoad = 'High';
    } else {
      monthlyLoad = 'Chronic';
    }

    return RecoveryTrendResult(
      currentDebt: currentDebt,
      previousDebt: previousDebt,
      monthlyDebt: monthlyDebt,
      difference: currentDebt - previousDebt,
      trend: trend,
      monthlyLoad: monthlyLoad,
    );
  }
}
