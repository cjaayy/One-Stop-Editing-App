import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

class ProfileService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<void> createUserDocument(UserModel user) async {
    try {
      await _client.from('profiles').upsert(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user document: $e');
    }
  }

  Future<UserModel?> getUserDocument(String uid) async {
    try {
      final data =
          await _client.from('profiles').select().eq('uid', uid).maybeSingle();
      if (data == null) {
        return null;
      }
      return UserModel.fromMap(Map<String, dynamic>.from(data as Map));
    } catch (e) {
      throw Exception('Failed to get user document: $e');
    }
  }

  Future<void> updateUserDocument(String uid, Map<String, dynamic> data) async {
    try {
      data['updated_at'] = DateTime.now().toIso8601String();
      await _client.from('profiles').update(data).eq('uid', uid);
    } catch (e) {
      throw Exception('Failed to update user document: $e');
    }
  }

  Future<bool> hasAdminUser() async {
    try {
      final data = await _client
          .from('profiles')
          .select('uid')
          .eq('is_admin', true)
          .limit(1);
      return data.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check admin user: $e');
    }
  }

  Future<void> updateEmailVerificationStatus(String uid, bool verified) async {
    try {
      await _client.from('profiles').update({
        'email_verified': verified,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('uid', uid);
    } catch (e) {
      throw Exception('Failed to update verification status: $e');
    }
  }

  Future<void> deleteUserDocument(String uid) async {
    try {
      await _client.from('profiles').delete().eq('uid', uid);
    } catch (e) {
      throw Exception('Failed to delete user document: $e');
    }
  }

  Stream<UserModel?> streamUserDocument(String uid) {
    return _client
        .from('profiles')
        .stream(primaryKey: ['uid'])
        .eq('uid', uid)
        .map(
          (rows) {
            if (rows.isEmpty) {
              return null;
            }
            return UserModel.fromMap(Map<String, dynamic>.from(rows.first));
          },
        );
  }
}
