import 'package:flutter/material.dart';

enum ShiftType { longDay, night, twilight, annualLeave, training, off }

extension ShiftTypeExtension on ShiftType {
  String get displayName {
    switch (this) {
      case ShiftType.longDay:
        return 'Long Day';

      case ShiftType.night:
        return 'Night';

      case ShiftType.twilight:
        return 'Twilight';

      case ShiftType.annualLeave:
        return 'Annual Leave';

      case ShiftType.training:
        return 'Training';

      case ShiftType.off:
        return 'Off';
    }
  }

  String get abbreviation {
    switch (this) {
      case ShiftType.longDay:
        return 'LD';

      case ShiftType.night:
        return 'N';

      case ShiftType.twilight:
        return 'TW';

      case ShiftType.annualLeave:
        return 'AL';

      case ShiftType.training:
        return 'TR';

      case ShiftType.off:
        return 'OFF';
    }
  }

  Color get colour {
    switch (this) {
      case ShiftType.longDay:
        return Colors.blue;

      case ShiftType.night:
        return Colors.deepPurple;

      case ShiftType.twilight:
        return Colors.orange;

      case ShiftType.training:
        return Colors.green;

      case ShiftType.annualLeave:
        return Colors.red;

      case ShiftType.off:
        return Colors.grey;
    }
  }

  int get defaultStartHour {
    switch (this) {
      case ShiftType.longDay:
        return 8;

      case ShiftType.night:
        return 20;

      case ShiftType.twilight:
        return 12;

      case ShiftType.training:
        return 9;

      case ShiftType.annualLeave:
      case ShiftType.off:
        return 0;
    }
  }

  int get defaultStartMinute => 0;

  int get defaultEndHour {
    switch (this) {
      case ShiftType.longDay:
        return 20;

      case ShiftType.night:
        return 8;

      case ShiftType.twilight:
        return 22;

      case ShiftType.training:
        return 17;

      case ShiftType.annualLeave:
      case ShiftType.off:
        return 0;
    }
  }

  int get defaultEndMinute => 0;
}
