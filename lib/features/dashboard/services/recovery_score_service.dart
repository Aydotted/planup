import '../../shifts/domain/entities/shift.dart';

import 'recovery_result.dart';

class RecoveryScoreService {
  static int calculateRecoveryDebt(List<Shift> shifts) {
    int debt = 0;

    for (final shift in shifts) {
      final type = shift.shiftType.toLowerCase();

      if (type.contains('night')) {
        debt += 4;
      } else if (type.contains('long')) {
        debt += 3;
      } else if (type.contains('twilight')) {
        debt += 2;
      } else if (type.contains('training')) {
        debt += 1;
      } else if (type.contains('off')) {
        debt -= 5;
      }

      final duration = shift.duration;

      if (duration != null) {
        final hours = duration.inMinutes / 60;

        if (hours >= 12) {
          debt += 2;
        } else if (hours >= 10) {
          debt += 1;
        }
      }
    }

    final workedShifts =
        shifts.where((s) => !s.shiftType.toLowerCase().contains('off')).toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    int streak = 1;

    for (int i = 1; i < workedShifts.length; i++) {
      final difference = workedShifts[i].date
          .difference(workedShifts[i - 1].date)
          .inDays;

      if (difference == 1) {
        streak++;
      } else {
        streak = 1;
      }

      if (streak >= 5) {
        debt += 2;
      }
    }

    return debt < 0 ? 0 : debt;
  }

  static String recoveryStatus(int debt) {
    if (debt <= 5) {
      return 'Recovered';
    }

    if (debt <= 12) {
      return 'Moderate';
    }

    if (debt <= 20) {
      return 'Elevated';
    }

    return 'High';
  }

  static int recommendedRecoveryDays(int debt) {
    return (debt / 5).ceil();
  }

  static RecoveryResult analyse(List<Shift> shifts) {
    final debt = calculateRecoveryDebt(shifts);

    final status = recoveryStatus(debt);

    final recoveryDays = debt / 5;

    final estimatedHours = debt * 3.5;

    return RecoveryResult(
      debt: debt,
      estimatedHours: estimatedHours,
      recoveryDays: recoveryDays,
      status: status,
    );
  }
}
