import '../../shifts/domain/entities/shift.dart';

class RecoveryAnalytics {
  int longestWorkStreak(List<Shift> shifts) {
    if (shifts.isEmpty) {
      return 0;
    }

    final sorted = [...shifts]..sort((a, b) => a.date.compareTo(b.date));

    int current = 1;
    int longest = 1;

    for (int i = 1; i < sorted.length; i++) {
      final difference = sorted[i].date.difference(sorted[i - 1].date).inDays;

      if (difference == 1) {
        current++;
      } else {
        current = 1;
      }

      if (current > longest) {
        longest = current;
      }
    }

    return longest;
  }

  int longestOffStreak(List<Shift> shifts) {
    final offShifts = shifts.where((s) => s.shiftType == 'Off').toList();

    if (offShifts.isEmpty) {
      return 0;
    }

    final sorted = [...offShifts]..sort((a, b) => a.date.compareTo(b.date));

    int current = 1;
    int longest = 1;

    for (int i = 1; i < sorted.length; i++) {
      final difference = sorted[i].date.difference(sorted[i - 1].date).inDays;

      if (difference == 1) {
        current++;
      } else {
        current = 1;
      }

      if (current > longest) {
        longest = current;
      }
    }

    return longest;
  }

  int totalNightShifts(List<Shift> shifts) {
    return shifts.where((s) => s.shiftType == 'Night').length;
  }

  int totalWeekendShifts(List<Shift> shifts) {
    return shifts.where((shift) {
      return shift.date.weekday == DateTime.saturday ||
          shift.date.weekday == DateTime.sunday;
    }).length;
  }

  String burnoutRisk(List<Shift> shifts) {
    final streak = longestWorkStreak(shifts);
    final nights = totalNightShifts(shifts);

    if (streak >= 7 || nights >= 10) {
      return 'High';
    }

    if (streak >= 5 || nights >= 6) {
      return 'Medium';
    }

    return 'Low';
  }
}
