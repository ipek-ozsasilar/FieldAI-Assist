import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../models/job.dart';
import '../models/ai_priority_model.dart';

class JobApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://127.0.0.1:3000';
    }

    return 'http://localhost:3000';
  }

  Future<List<Job>> getTodayJobs() async {
    final uri = Uri.parse('$baseUrl/api/jobs/today');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      debugPrint(
        'Today jobs request failed. '
        'Status: ${response.statusCode}, Body: ${response.body}',
      );
      throw Exception('Bugünkü işler alınamadı.');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (data['success'] != true) {
      debugPrint('Backend jobs returned success=false. Body: ${response.body}');
      throw Exception('Backend işler isteği başarısız döndü.');
    }

    final jobsJson = data['jobs'] as List<dynamic>? ?? [];

    return jobsJson
        .map((item) => Job.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<AiPriorityResult> prioritizeTodayJobs() async {
    final uri = Uri.parse('$baseUrl/api/ai/prioritize-jobs');

    final response = await http.post(uri);

    if (response.statusCode != 200) {
      debugPrint(
        'AI prioritize request failed. '
        'Status: ${response.statusCode}, Body: ${response.body}',
      );
      throw Exception('AI önceliklendirme başarısız oldu.');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (data['success'] != true) {
      debugPrint('Backend AI returned success=false. Body: ${response.body}');
      throw Exception('Backend AI isteği başarısız döndü.');
    }

    final ai = data['ai'] as Map<String, dynamic>? ?? {};

    return AiPriorityResult.fromJson({...ai, 'jobs': data['jobs'] ?? []});
  }
}
