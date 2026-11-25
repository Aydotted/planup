import 'package:uuid/uuid.dart';

class RecurrenceSeries {
  final String seriesId;

  final DateTime createdAt;

  const RecurrenceSeries({required this.seriesId, required this.createdAt});

  static String generateSeriesId() {
    return const Uuid().v4();
  }
}
