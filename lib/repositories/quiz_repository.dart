import 'package:ventur_2/models/quiz_question.dart';
import 'package:ventur_2/data/quiz_questions.dart';

class QuizRepository {
  Future<List<QuizQuestion>> getQuestions() async {
    return questions;
  }
}
