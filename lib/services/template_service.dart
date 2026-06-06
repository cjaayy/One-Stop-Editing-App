import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/admin_template_model.dart';

class TemplateService {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<List<AdminTemplateModel>> streamTemplates() {
    return _client
        .from('custom_templates')
        .stream(primaryKey: ['id']).map((rows) {
      final templates = rows
          .map((row) =>
              AdminTemplateModel.fromMap(Map<String, dynamic>.from(row)))
          .toList();
      templates
          .sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
      return templates;
    });
  }

  Stream<List<AdminTemplateModel>> streamActiveTemplates() {
    return streamTemplates().map(
      (templates) => templates.where((template) => template.isActive).toList(),
    );
  }

  Future<void> createTemplate(AdminTemplateModel template) async {
    try {
      await _client.from('custom_templates').insert(
            template
                .copyWith(
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                )
                .toMap(),
          );
    } catch (e) {
      throw Exception('Failed to create template: $e');
    }
  }

  Future<void> deleteTemplate(String id) async {
    try {
      await _client.from('custom_templates').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete template: $e');
    }
  }

  Future<void> updateTemplateStatus(String id, bool isActive) async {
    try {
      await _client.from('custom_templates').update({
        'is_active': isActive,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update template status: $e');
    }
  }
}
