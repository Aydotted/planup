import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/onboarding_state.dart';

class OnboardingProvider extends ChangeNotifier {
  final Box<OnboardingState> _box = Hive.box<OnboardingState>('onboarding');

  bool get isCompleted =>
      _box.get('state', defaultValue: OnboardingState())!.completed;

  Future<void> completeOnboarding() async {
    await _box.put('state', OnboardingState(completed: true));
    notifyListeners();
  }
}
