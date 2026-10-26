import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Renders an image from either a network URL (with disk caching) or a bundled
/// asset, chosen automatically from the path. If a network image fails to load
/// and a [fallbackUrl] is provided, it loads that instead (for country levels
/// the fallback is the flag, which always resolves) so the UI never shows a
/// broken image.
class SmartImage extends StatelessWidget {
  final String path;
  final String? fallbackUrl;
  final BoxFit fit;

  const SmartImage({
    super.key,
    required this.path,
    this.fallbackUrl,
    this.fit = BoxFit.cover,
  });

  bool get _isNetwork => path.startsWith('http://') || path.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (!_isNetwork) {
      return Image.asset(path, fit: fit);
    }
    return _network(path, allowFallback: true);
  }

  Widget _network(String url, {required bool allowFallback}) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: (context, _) => const ColoredBox(
        color: Color(0xFFE9EEF3),
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      ),
      errorWidget: (context, _, __) {
        if (allowFallback && fallbackUrl != null && fallbackUrl != url) {
          return _network(fallbackUrl!, allowFallback: false);
        }
        return const ColoredBox(
          color: Color(0xFFE9EEF3),
          child: Center(
            child: Icon(Icons.image_not_supported_outlined,
                color: Colors.black26, size: 40),
          ),
        );
      },
    );
  }
}
