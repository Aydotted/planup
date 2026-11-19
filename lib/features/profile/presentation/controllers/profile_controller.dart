import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// Domain
import '../../../profile/domain/entities/user_profile.dart';

class ProfileController extends ChangeNotifier {
  late Box<UserProfile> _profileBox;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserProfile? _profile;
  UserProfile? get profile => _profile;

  // ------------------------------------------------------------
  // INITIALIZATION
  // ------------------------------------------------------------
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    _profileBox = Hive.box<UserProfile>('profileBox');

    if (_profileBox.isNotEmpty) {
      _profile = _profileBox.values.first;
    }

    _isLoading = false;
    notifyListeners();
  }

  // ------------------------------------------------------------
  // CREATE OR UPDATE PROFILE
  // ------------------------------------------------------------
  Future<void> saveProfile(UserProfile updated) async {
    if (_profile == null) {
      // First-time creation
      await _profileBox.put(updated.id, updated);
    } else {
      // Update existing
      await _profileBox.put(updated.id, updated);
    }

    _profile = updated;
    notifyListeners();
  }

  // ------------------------------------------------------------
  // UPDATE PROFILE
  // ------------------------------------------------------------
  Future<void> updateProfile({
    required String name,
    required int dailyGoal,
    required bool notificationsEnabled,
  }) async {
    if (_profile == null) return;

    final updated = _profile!.copyWith(
      name: name,
      dailyGoal: dailyGoal,
      notificationsEnabled: notificationsEnabled,
    );

    await saveProfile(updated);
  }

  // ------------------------------------------------------------
  // UPDATE NAME
  // ------------------------------------------------------------
  Future<void> updateName(String name) async {
    if (_profile == null) return;

    final updated = _profile!.copyWith(name: name);
    await saveProfile(updated);
  }

  // ------------------------------------------------------------
  // UPDATE EMAIL
  // ------------------------------------------------------------
  Future<void> updateEmail(String email) async {
    if (_profile == null) return;

    final updated = _profile!.copyWith(email: email);
    await saveProfile(updated);
  }

  // ------------------------------------------------------------
  // UPDATE AVATAR
  // ------------------------------------------------------------
  Future<void> updateAvatar(String avatarPath) async {
    if (_profile == null) return;

    final updated = _profile!.copyWith(avatar: avatarPath);
    await saveProfile(updated);
  }

  // ------------------------------------------------------------
  // UPDATE DAILY GOAL
  // ------------------------------------------------------------
  Future<void> updateDailyGoal(int goal) async {
    if (_profile == null) return;

    final updated = _profile!.copyWith(dailyGoal: goal);

    await saveProfile(updated);
  }

  // ------------------------------------------------------------
  // DELETE PROFILE
  // ------------------------------------------------------------
  Future<void> deleteProfile() async {
    if (_profile == null) return;

    await _profileBox.delete(_profile!.id);
    _profile = null;
    notifyListeners();
  }
}
