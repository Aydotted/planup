class BurnoutInput {
  final int recoveryDebt;

  final String recoveryTrend;

  final String monthlyLoad;

  final double taskCompletionRate;

  final double habitCompletionRate;

  const BurnoutInput({
    required this.recoveryDebt,
    required this.recoveryTrend,
    required this.monthlyLoad,
    required this.taskCompletionRate,
    required this.habitCompletionRate,
  });
}
