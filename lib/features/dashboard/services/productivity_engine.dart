import '../../tasks/domain/entities/task.dart';
import '../../shifts/domain/entities/shift.dart';

class ProductivityAnalytics {
  double completionRate({
    required List<Task> tasks,
    required List<Shift> shifts,
    required String shiftType,
  }) {
    final shiftDates = shifts
        .where((s) => s.shiftType == shiftType)
        .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
        .toSet();

    final matchingTasks = tasks.where((task) {
      final taskDate = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );

      return shiftDates.contains(taskDate);
    }).toList();

    if (matchingTasks.isEmpty) {
      return 0;
    }

    final completed = matchingTasks.where((t) => t.isCompleted).length;

    return (completed / matchingTasks.length) * 100;
  }

  String mostProductiveShift({
    required List<Task> tasks,
    required List<Shift> shifts,
  }) {
    final shiftTypes = shifts.map((s) => s.shiftType).toSet();

    if (shiftTypes.isEmpty) {
      return 'No Data';
    }

    String bestShift = '';
    double highestRate = 0;

    for (final type in shiftTypes) {
      final rate = completionRate(
        tasks: tasks,
        shifts: shifts,
        shiftType: type,
      );

      if (rate > highestRate) {
        highestRate = rate;
        bestShift = type;
      }
    }

    return bestShift;
  }

  String leastProductiveShift({
    required List<Task> tasks,
    required List<Shift> shifts,
  }) {
    final shiftTypes = shifts.map((s) => s.shiftType).toSet();

    if (shiftTypes.isEmpty) {
      return 'No Data';
    }

    String worstShift = '';
    double lowestRate = 100;

    for (final type in shiftTypes) {
      final rate = completionRate(
        tasks: tasks,
        shifts: shifts,
        shiftType: type,
      );

      if (rate < lowestRate) {
        lowestRate = rate;
        worstShift = type;
      }
    }

    return worstShift;
  }
}
