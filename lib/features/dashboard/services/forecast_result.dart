class ForecastResult {
  final double expectedTaskRate;

  final double expectedHabitRate;

  final String expectedBurnout;

  final String recommendation;

  const ForecastResult({
    required this.expectedTaskRate,
    required this.expectedHabitRate,
    required this.expectedBurnout,
    required this.recommendation,
  });
}
