import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/controllers/theme_controller.dart';
import '../../onboarding/presentation/controllers/onboarding_controller.dart';
import '../../profile/presentation/controllers/profile_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int dailyGoal = 5;
  ThemeMode selectedTheme = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeController>();
    final profileProvider = context.read<ProfileController>();
    final onboardingProvider = context.read<OnboardingProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to PlanUp!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              const Text(
                'Let’s set up your preferences to get started.',
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 32),

              const Text(
                'Choose Theme',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12),

              DropdownButton<ThemeMode>(
                value: selectedTheme,
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light'),
                  ),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                ],
                onChanged: (mode) {
                  if (mode != null) {
                    setState(() => selectedTheme = mode);
                  }
                },
              ),

              const SizedBox(height: 32),

              const Text(
                'Daily Task Goal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12),

              Slider(
                value: dailyGoal.toDouble(),
                min: 1,
                max: 20,
                divisions: 19,
                label: '$dailyGoal tasks',
                onChanged: (value) {
                  setState(() => dailyGoal = value.toInt());
                },
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Save theme
                    themeProvider.setThemeMode(selectedTheme);

                    // Save daily goal
                    profileProvider.updateDailyGoal(dailyGoal);

                    // Mark onboarding complete
                    onboardingProvider.completeOnboarding();

                    // Navigate to home
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text('Get Started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
