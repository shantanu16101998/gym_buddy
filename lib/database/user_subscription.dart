import 'package:gym_buddy/database/database_helper.dart';
import 'package:gym_buddy/models/user_subscription.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';

Future<void> insertUser(UserSubscription user) async {
  final db = await DatabaseHelper().database;

  await db.insert(
    'user',
    user.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// A method that retrieves all the dogs from the dogs table.
Future<List<UserSubscription>> getAllUsers() async {
  // Get a reference to the database.
  final db = await DatabaseHelper().database;

  // Query the table for all the dogs.
  final List<Map<String, Object?>> userMaps = await db.query('user');

  print("all users from db $userMaps");

  return [
    for (final {
          'id': id as String,
          'name': name as String,
          'startDate': startDate as String,
          'endDate': endDate as String,
          'expiringDays': expiringDays as int?,
          'expiredDays': expiredDays as int?,
          'profilePic': profilePic as String?,
          'contact': contact as String,
          'experience': experience as String?,
        } in userMaps)
      UserSubscription(name, startDate, endDate, expiringDays, expiredDays, id,
          profilePic, contact, experience),
  ];
}

Future<void> updateUser(UserSubscription user) async {
  final db = await DatabaseHelper().database;

  await db.update(
    'user',
    user.toMap(),
    where: 'id = ?',
    whereArgs: [user.id],
  );
}

Future<void> deleteUser(String id) async {
  final db = await DatabaseHelper().database;

  await db.delete(
    'user',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> deleteAllUser() async {
  final db = await DatabaseHelper().database;

  await db.delete('user');
}
