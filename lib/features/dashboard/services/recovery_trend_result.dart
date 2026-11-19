class RecoveryTrendResult {
  final int currentDebt;
  final int previousDebt;
  final int monthlyDebt;

  final int difference;

  final String trend;
  final String monthlyLoad;

  const RecoveryTrendResult({
    required this.currentDebt,
    required this.previousDebt,
    required this.monthlyDebt,
    required this.difference,
    required this.trend,
    required this.monthlyLoad,
  });
}
