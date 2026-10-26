import 'package:ventur_2/models/game_mode.dart';
import 'package:ventur_2/models/image_credit.dart';

class QuizQuestion {
  final String id;
  final GameMode mode;
  final List<String> imageUrls;
  final String correctAnswer;
  final List<String> options;
  final String continent;
  final String? description;
  final String? funfact;

  /// Attribution per image, index-aligned with [imageUrls]. May be empty for
  /// locally-bundled fallback questions.
  final List<ImageCredit> imageCredits;

  const QuizQuestion({
    required this.id,
    this.mode = GameMode.country,
    required this.imageUrls,
    required this.correctAnswer,
    required this.options,
    required this.continent,
    this.description,
    this.funfact,
    this.imageCredits = const [],
  });

  /// A guaranteed-loadable image to show if a primary image URL fails. For
  /// country levels this is the flag (served last), which always resolves.
  String? get fallbackImageUrl => imageUrls.isNotEmpty ? imageUrls.last : null;

  /// Credit for the image at [index], if available.
  ImageCredit? creditAt(int index) =>
      (index >= 0 && index < imageCredits.length) ? imageCredits[index] : null;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      mode: GameMode.fromName(json['mode'] as String?),
      imageUrls: ((json['imageUrls'] as List?) ?? const [])
          .map((e) => e as String)
          .toList(),
      correctAnswer: json['correctAnswer'] as String,
      options: ((json['options'] as List?) ?? const [])
          .map((e) => e as String)
          .toList(),
      continent: (json['continent'] as String?) ?? '',
      description: json['description'] as String?,
      funfact: json['funfact'] as String?,
      imageCredits: ((json['imageCredits'] as List?) ?? const [])
          .map((e) => ImageCredit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
