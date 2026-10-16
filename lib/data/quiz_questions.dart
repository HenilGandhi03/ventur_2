import '../models/quiz_question.dart';

const questions = [
  QuizQuestion(
    imageUrls: [
      'assets/images/italy.jpg',
      'assets/images/italy2.jpg',
      'assets/images/italy3.jpg',
    ],
    correctAnswer: 'Italy',
    continent: 'Europe',
    options: ['Italy', 'Greece', 'Spain', 'France'],
  ),

  QuizQuestion(
    imageUrls: [
      'assets/images/france.jpg',
      'assets/images/france2.jpg',
      'assets/images/france3.jpg',
    ],
    correctAnswer: 'France',
    continent: 'Europe',
    options: ['France', 'Italy', 'Spain', 'Portugal'],
  ),
];
