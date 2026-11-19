class FocusScoreService {
  static int calculate({
    required String burnoutRisk,
    required int recoveryDebt,
    required double forecastRate,
    required double taskCompletionRate,
    required double habitCompletionRate,
  }) {
    int score = 100;

    score -= recoveryDebt;

    if (burnoutRisk == 'Moderate') {
      score -= 10;
    }

    if (burnoutRisk == 'High') {
      score -= 20;
    }

    score += ((forecastRate - 0.5) * 20).round();

    score += ((taskCompletionRate - 0.5) * 20).round();

    score += ((habitCompletionRate - 0.5) * 20).round();

    return score.clamp(0, 100);
  }
}
