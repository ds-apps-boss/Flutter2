import 'package:flutter/material.dart';

class BeepBurstOverlay extends StatefulWidget {
  final String asset;
  final Duration total;
  final double maxScreenFrac;
  final bool show;
  final VoidCallback? onDone;

  const BeepBurstOverlay({
    super.key,
    required this.asset,
    this.total = const Duration(milliseconds: 1600),
    this.maxScreenFrac = 0.9,
    this.show = false,
    this.onDone,
  });

  @override
  State<BeepBurstOverlay> createState() => _BeepBurstOverlayState();
}

class _BeepBurstOverlayState extends State<BeepBurstOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _scale; // 0.1 → 1.0 → 1.3
  late final Animation<double> _opacity; // 1.0 → 1.0 → 0.0

  @override
  void initState() {
    super.initState();

    _c = AnimationController(vsync: this, duration: widget.total);

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.1,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 45,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 25),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.35,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_c);

    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 70),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_c);

    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        widget.onDone?.call();
      }
    });

    if (widget.show) _c.forward(from: 0);
  }

  @override
  void didUpdateWidget(BeepBurstOverlay old) {
    super.didUpdateWidget(old);
    if (widget.show && !old.show) _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final maxSize = shortestSide * widget.maxScreenFrac;

    return IgnorePointer(
      ignoring: true,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          if (_c.isDismissed && !widget.show) return const SizedBox.shrink();
          return Center(
            child: Opacity(
              opacity: _opacity.value,
              child: Transform.scale(
                scale: _scale.value,
                child: SizedBox(
                  width: maxSize,
                  height: maxSize,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(widget.asset),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
