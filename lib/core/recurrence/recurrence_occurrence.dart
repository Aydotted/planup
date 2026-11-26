class RecurrenceOccurrence {
  final String occurrenceId;

  final String seriesId;

  final DateTime occurrenceDate;

  final bool completed;

  const RecurrenceOccurrence({
    required this.occurrenceId,
    required this.seriesId,
    required this.occurrenceDate,
    this.completed = false,
  });
}
