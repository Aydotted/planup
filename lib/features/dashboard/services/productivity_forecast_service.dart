import '../../shifts/domain/entities/shift.dart';

import 'forecast_input.dart';
import 'forecast_result.dart';

class ProductivityForecastService {
  static ForecastResult forecast({required ForecastInput input}) {
    double expectedTaskRate = input.taskRates[input.upcomingShift] ?? 0.0;

    double expectedHabitRate = input.habitRates[input.upcomingShift] ?? 0.0;

    if (input.recoveryTrend == 'Declining') {
      expectedTaskRate -= 0.10;
      expectedHabitRate -= 0.10;
    }

    if (input.monthlyLoad == 'High') {
      expectedTaskRate -= 0.05;
      expectedHabitRate -= 0.05;
    }

    if (input.monthlyLoad == 'Chronic') {
      expectedTaskRate -= 0.10;
      expectedHabitRate -= 0.10;
    }

    if (input.recoveryDebt > 20) {
      expectedTaskRate -= 0.10;
      expectedHabitRate -= 0.10;
    }

    if (input.recoveryDebt > 30) {
      expectedTaskRate -= 0.15;
      expectedHabitRate -= 0.15;
    }

    expectedTaskRate = expectedTaskRate.clamp(0.0, 1.0);

    expectedHabitRate = expectedHabitRate.clamp(0.0, 1.0);

    String recommendation;

    if (expectedTaskRate < 0.5) {
      recommendation = 'Reduce planned workload by approximately 30%.';
    } else if (expectedTaskRate < 0.7) {
      recommendation =
          'Maintain a moderate workload and prioritise important tasks.';
    } else {
      recommendation = 'Current workload appears sustainable.';
    }

    if (input.burnoutRisk == 'High') {
      recommendation = 'High burnout risk detected. Prioritise recovery and keep workload light.';
    }

    return ForecastResult(
      expectedTaskRate: expectedTaskRate,
      expectedHabitRate: expectedHabitRate,
      expectedBurnout: input.burnoutRisk,
      recommendation: recommendation,
    );
  }

  static Shift? nextShift(List<Shift> shifts) {
    final now = DateTime.now();

    final futureShifts = shifts
        .where(
          (shift) => shift.date.isAfter(now.subtract(const Duration(days: 1))),
        )
        .toList();

    if (futureShifts.isEmpty) {
      return null;
    }

    futureShifts.sort((a, b) => a.date.compareTo(b.date));

    return futureShifts.first;
  }
}
