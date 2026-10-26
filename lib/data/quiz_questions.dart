import '../models/quiz_question.dart';

const questions = [
  QuizQuestion(
    id: 'country_italy',
    imageUrls: [
      'assets/images/italy.jpg',
      'assets/images/italy2.jpg',
      'assets/images/italy3.jpg',
    ],
    description:
        'This country is known for its rich history, art, and cuisine.',
    funfact:
        'Italy is home to the largest number of UNESCO World Heritage Sites in the world.',
    correctAnswer: 'Italy',
    continent: 'Europe',
    options: ['Italy', 'Greece', 'Spain', 'France'],
  ),

  QuizQuestion(
    id: 'country_france',
    imageUrls: [
      'assets/images/france.jpg',
      'assets/images/france2.jpg',
      'assets/images/france3.jpg',
    ],
    description:
        'This country is known for its rich history, art, and cuisine.',
    funfact:
        'France is the most visited country in the world, attracting millions of tourists each year.',
    correctAnswer: 'France',
    continent: 'Europe',
    options: ['France', 'Italy', 'Spain', 'Portugal'],
  ),
];
