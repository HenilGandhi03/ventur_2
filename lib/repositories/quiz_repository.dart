import 'package:ventur_2/models/game_mode.dart';
import 'package:ventur_2/models/quiz_question.dart';
import 'package:ventur_2/services/api_client.dart';

/// Fetches levels from the backend API.
///
/// Levels are paged (the API caps page size), so this walks pages until the
/// full set for a mode is retrieved, then maps them into [QuizQuestion]s in
/// level order. The rest of the app is unaware of transport details.
class QuizRepository {
  final ApiClient _api;
  final GameMode mode;

  QuizRepository({ApiClient? api, this.mode = GameMode.country})
    : _api = api ?? ApiClient();

  Future<List<QuizQuestion>> getQuestions() async {
    const limit = 100;
    var page = 1;
    final questions = <QuizQuestion>[];

    while (true) {
      final body = await _api.getJson(
        '/levels',
        query: {'mode': mode.name, 'page': page, 'limit': limit},
      );

      final data = (body is Map ? body['data'] : null);
      if (data is! List) {
        throw const ApiException('Unexpected response shape for /levels.');
      }

      for (final item in data) {
        questions.add(QuizQuestion.fromJson(item as Map<String, dynamic>));
      }

      final meta = (body is Map ? body['meta'] : null);
      final hasNext = meta is Map && meta['hasNextPage'] == true;
      if (!hasNext) break;
      page += 1;
    }

    return questions;
  }
}
