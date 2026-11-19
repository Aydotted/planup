import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// Shared service

class OnboardingController extends ChangeNotifier {
  late Box _box;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isFirstRun => _box.get('isFirstRun', defaultValue: true);

  bool get tutorialCompleted =>
      _box.get('tutorialCompleted', defaultValue: false);

  // ------------------------------------------------------------
  // INITIALIZATION
  // ------------------------------------------------------------
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _box = Hive.box('settings');

    _isLoading = false;
    notifyListeners();
  }

  // ------------------------------------------------------------
  // MARK ONBOARDING COMPLETE
  // ------------------------------------------------------------
  Future<void> completeOnboarding() async {
    await _box.put('isFirstRun', false);
    notifyListeners();
  }

  // ------------------------------------------------------------
  // MARK TUTORIAL COMPLETE
  // ------------------------------------------------------------
  Future<void> completeTutorial() async {
    await _box.put('tutorialCompleted', true);
    notifyListeners();
  }

  // ------------------------------------------------------------
  // RESET ONBOARDING (for debugging)
  // ------------------------------------------------------------
  Future<void> resetOnboarding() async {
    await _box.put('isFirstRun', true);
    await _box.put('tutorialCompleted', false);
    notifyListeners();
  }

  // ------------------------------------------------------------
  // USE SHARED SERVICE (optional)
  // ------------------------------------------------------------
  Future<void> runOnboardingFlow() async {
    await completeOnboarding();
  }
}
