/// Attribution for a single image, as supplied by the backend.
///
/// Landmark photos come from Wikimedia Commons (the [sourceUrl] file page holds
/// the exact author + licence); flags come from flagcdn.com (public domain).
class ImageCredit {
  final String title;
  final String source;
  final String author;
  final String license;
  final String sourceUrl;

  const ImageCredit({
    required this.title,
    required this.source,
    required this.author,
    required this.license,
    required this.sourceUrl,
  });

  /// Short line for display under an image, e.g.
  /// "Eiffel Tower, Paris · Wikimedia Commons".
  String get shortLabel => '$title · $source';

  factory ImageCredit.fromJson(Map<String, dynamic> json) {
    return ImageCredit(
      title: (json['title'] as String?) ?? 'Image',
      source: (json['source'] as String?) ?? 'Unknown',
      author: (json['author'] as String?) ?? 'Unknown',
      license: (json['license'] as String?) ?? 'Unknown',
      sourceUrl: (json['sourceUrl'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'source': source,
    'author': author,
    'license': license,
    'sourceUrl': sourceUrl,
  };
}
