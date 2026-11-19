import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 5)
class UserProfile extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int dailyGoal;

  @HiveField(3)
  bool notificationsEnabled;

  @HiveField(4)
  String? email;

  @HiveField(5)
  String? avatar;

  UserProfile({
    String? id,
    required this.name,
    required this.dailyGoal,
    required this.notificationsEnabled,
    this.email,
    this.avatar,
  }) : id = id ?? const Uuid().v4();

  UserProfile copyWith({
    String? name,
    int? dailyGoal,
    bool? notificationsEnabled,
    String? email,
    String? avatar,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }
}
