import 'package:hive/hive.dart';

part 'onboarding_state.g.dart';

@HiveType(typeId: 20)
class OnboardingState {
  @HiveField(0)
  bool completed;

  OnboardingState({this.completed = false});
}
