class RecoveryResult {
  final int debt;
  final double estimatedHours;
  final double recoveryDays;
  final String status;

  const RecoveryResult({
    required this.debt,
    required this.estimatedHours,
    required this.recoveryDays,
    required this.status,
  });
}
