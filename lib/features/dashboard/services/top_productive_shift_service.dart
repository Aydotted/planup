class TopProductiveShiftResult {
  final String bestShift;
  final double bestRate;

  final String worstShift;
  final double worstRate;

  const TopProductiveShiftResult({
    required this.bestShift,
    required this.bestRate,
    required this.worstShift,
    required this.worstRate,
  });
}

class TopProductiveShiftService {
  static TopProductiveShiftResult analyse(Map<String, double> rates) {
    if (rates.isEmpty) {
      return const TopProductiveShiftResult(
        bestShift: 'Unknown',
        bestRate: 0,
        worstShift: 'Unknown',
        worstRate: 0,
      );
    }

    final sorted = rates.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return TopProductiveShiftResult(
      bestShift: sorted.first.key,
      bestRate: sorted.first.value,
      worstShift: sorted.last.key,
      worstRate: sorted.last.value,
    );
  }
}
