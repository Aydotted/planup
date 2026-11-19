class ForecastInput {
  final String upcomingShift;

  final Map<String, double> taskRates;

  final Map<String, double> habitRates;

  final String burnoutRisk;

  final String recoveryTrend;

  final String monthlyLoad;

  final int recoveryDebt;

  const ForecastInput({
    required this.upcomingShift,
    required this.taskRates,
    required this.habitRates,
    required this.burnoutRisk,
    required this.recoveryTrend,
    required this.monthlyLoad,
    required this.recoveryDebt,
  });
}
