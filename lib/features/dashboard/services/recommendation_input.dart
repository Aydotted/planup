class RecommendationInput {
  final int recoveryDebt;

  final String recoveryTrend;

  final String monthlyLoad;

  final String burnoutRisk;

  final double taskCompletionRate;

  final double habitCompletionRate;

  final Map<String, double> taskRates;

  final Map<String, double> habitRates;

  const RecommendationInput({
    required this.recoveryDebt,
    required this.recoveryTrend,
    required this.monthlyLoad,
    required this.burnoutRisk,
    required this.taskCompletionRate,
    required this.habitCompletionRate,
    required this.taskRates,
    required this.habitRates,
  });
}
