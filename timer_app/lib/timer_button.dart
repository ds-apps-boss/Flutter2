import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerButtonData {
  final String name;
  final Alignment pPos;
  final Alignment aPos;
  final Size newSize;
  final Image image;
  final VoidCallback onTap;

  TimerButtonData({
    required this.name,
    required this.pPos,
    required this.aPos,
    required this.newSize,
    required this.image,
    required this.onTap,
  });
}

class TimerButton extends StatefulWidget {
  final TimerButtonData data;
  const TimerButton({super.key, required this.data});

  @override
  State<TimerButton> createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  bool _isPressed = false;
  final player = AudioPlayer();

  Future<void> _playClick() async {
    await player.play(AssetSource('sounds/01s.wav'));
  }

  @override
  Widget build(BuildContext context) {
    final pos = _isPressed ? widget.data.aPos : widget.data.pPos;
    return AnimatedAlign(
      alignment: pos,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTapDown: (_) async {
          setState(() => _isPressed = true);
          _playClick();
        },

        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.data.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: SizedBox(
          width: widget.data.newSize.width,
          height: widget.data.newSize.height,
          child: widget.data.image,
        ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}

//--------------------------------------------

enum ButtonId { left, top, right }

class TimerButtonSpec {
  final ButtonId id;
  final Alignment pPos;
  final Alignment aPos;
  final Size size;
  final VoidCallback onTap;
  final String? soundAsset;

  const TimerButtonSpec({
    required this.id,
    required this.pPos,
    required this.aPos,
    required this.size,
    required this.onTap,
    this.soundAsset,
  });
}

//controller
class TimerButtonController extends ChangeNotifier {
  bool _pressed = false;
  bool get pressed => _pressed;

  void press() {
    if (_pressed) return;
    _pressed = true;
    notifyListeners();
  }

  void release() {
    if (!_pressed) return;
    _pressed = false;
    notifyListeners();
  }
}

//--------------

class InvisibleButton extends StatefulWidget {
  final TimerButtonSpec spec;
  final TimerButtonController controller;

  const InvisibleButton({
    super.key,
    required this.spec,
    required this.controller,
  });

  @override
  State<InvisibleButton> createState() => _InvisibleButtonState();
}

class _InvisibleButtonState extends State<InvisibleButton> {
  // bool _isPressed = false;
  final player = AudioPlayer();

  Future<void> _playClick() async {
    await player.play(AssetSource('sounds/01s.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.spec.pPos,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          widget.controller.press();
          _playClick();
        },
        onTapCancel: () => widget.controller.release(),
        onTapUp: (_) {
          widget.controller.release();
          widget.spec.onTap();
        },
        child: SizedBox(
          width: widget.spec.size.width,
          height: widget.spec.size.height,
        ),
      ),
    );
  }
}

class VisibleButton extends StatelessWidget {
  final TimerButtonSpec spec;
  final TimerButtonController controller;
  final Image image;

  const VisibleButton({
    super.key,
    required this.spec,
    required this.controller,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final pos = controller.pressed ? spec.aPos : spec.pPos;
        return AnimatedAlign(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          alignment: pos,
          child: SizedBox(
            width: spec.size.width,
            height: spec.size.height,
            child: image,
          ),
        );
      },
    );
  }
}


/*
class ButtonSfx extends StatefulWidget {
  const ButtonSfx({
    super.key,
    required this.controller,
    this.asset = 'sounds/click.wav',
  });

  final TimerButtonController controller;
  final String asset;

  @override
  State<ButtonSfx> createState() => _ButtonSfxState();
}

class _ButtonSfxState extends State<ButtonSfx> {
 // late final AudioPlayer _sfx;
  late bool _prev;

  @override
  void initState() {
    super.initState();
    _prev = widget.controller.pressed;
    //_sfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);    
    //_sfx.setSourceAsset(widget.asset);
    widget.controller.addListener(_onChanged);
  }

  void _onChanged() {
    final now = widget.controller.pressed;
    if (!_prev && now) {
      
      //_sfx.stop().then((_) => _sfx.resume());
      
    }
    _prev = now;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    //_sfx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {   
    return const SizedBox.shrink();
  }
}
*/