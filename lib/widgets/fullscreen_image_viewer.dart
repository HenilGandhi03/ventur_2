import 'package:flutter/material.dart';
import 'package:ventur_2/widgets/smart_image.dart';

/// Opens [imagePath] full screen with pinch-to-zoom, pan and double-tap zoom.
Future<void> showFullscreenImage(
  BuildContext context,
  String imagePath, {
  String? fallbackUrl,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) =>
          FullscreenImageViewer(imagePath: imagePath, fallbackUrl: fallbackUrl),
    ),
  );
}

class FullscreenImageViewer extends StatefulWidget {
  final String imagePath;
  final String? fallbackUrl;

  const FullscreenImageViewer({
    super.key,
    required this.imagePath,
    this.fallbackUrl,
  });

  @override
  State<FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<FullscreenImageViewer> {
  final TransformationController _transform = TransformationController();
  Offset _doubleTapPosition = Offset.zero;

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _toggleZoom() {
    if (_transform.value != Matrix4.identity()) {
      _transform.value = Matrix4.identity();
      return;
    }

    const scale = 3.0;
    final p = _doubleTapPosition;
    _transform.value = Matrix4.identity()
      ..translate(-p.dx * (scale - 1), -p.dy * (scale - 1))
      ..scale(scale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onDoubleTapDown: (d) => _doubleTapPosition = d.localPosition,
        onDoubleTap: _toggleZoom,
        child: InteractiveViewer(
          transformationController: _transform,
          minScale: 1,
          maxScale: 5,
          child: Center(
            child: SmartImage(
              path: widget.imagePath,
              fallbackUrl: widget.fallbackUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
