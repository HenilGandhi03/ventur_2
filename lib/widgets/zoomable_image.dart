import 'package:flutter/material.dart';
import 'package:ventur_2/widgets/fullscreen_image_viewer.dart';

/// Image with a magnifying-glass toggle (bottom-left) and a full-screen
/// button (bottom-right). With the magnifier on, touching/dragging over the
/// image shows a lens that magnifies the area under the finger.
class ZoomableImage extends StatefulWidget {
  final String imagePath;
  final double height;
  final double borderRadius;

  const ZoomableImage({
    super.key,
    required this.imagePath,
    required this.height,
    this.borderRadius = 16,
  });

  @override
  State<ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage> {
  static const double _lensSize = 120;
  static const double _lensScale = 2.5;
  // Lens floats above the finger so the finger doesn't cover it.
  static const double _lensLift = 85;

  bool _magnifierOn = false;
  Offset? _touch;

  void _setTouch(Offset? p) => setState(() => _touch = p);

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return Material(
      color: active ? Colors.amber : Colors.black.withOpacity(0.55),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 22,
            color: active ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _lens(Size box) {
    final touch = _touch!;
    final half = _lensSize / 2;
    final center = Offset(
      touch.dx.clamp(half, box.width - half),
      (touch.dy - _lensLift).clamp(half, box.height - half),
    );

    return Positioned(
      left: center.dx - half,
      top: center.dy - half,
      child: IgnorePointer(
        child: RawMagnifier(
          size: const Size.square(_lensSize),
          magnificationScale: _lensScale,
          // Magnify the point under the finger, not the lens centre.
          focalPointOffset: touch - center,
          decoration: const MagnifierDecoration(
            shape: CircleBorder(side: BorderSide(color: Colors.white, width: 3)),
            shadows: [BoxShadow(color: Colors.black38, blurRadius: 8)],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final box = constraints.biggest;

            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(widget.imagePath, fit: BoxFit.cover),

                if (_magnifierOn)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanDown: (d) => _setTouch(d.localPosition),
                    onPanUpdate: (d) => _setTouch(d.localPosition),
                    onPanEnd: (_) => _setTouch(null),
                    onPanCancel: () => _setTouch(null),
                  ),

                if (_magnifierOn && _touch != null) _lens(box),

                Positioned(
                  left: 8,
                  bottom: 8,
                  child: _roundButton(
                    icon: Icons.search,
                    active: _magnifierOn,
                    onTap: () => setState(() {
                      _magnifierOn = !_magnifierOn;
                      _touch = null;
                    }),
                  ),
                ),

                Positioned(
                  right: 8,
                  bottom: 8,
                  child: _roundButton(
                    icon: Icons.fullscreen,
                    onTap: () => showFullscreenImage(context, widget.imagePath),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
