import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerButtonData {
  final String name;
  final Alignment pPos;
  final Alignment aPos;
  //final Size fileOriginalSize;
  final Size newSize;
  final Image image;
  final VoidCallback onTap;

  TimerButtonData({
    required this.name,
    required this.pPos,
    required this.aPos,
    //required this.fileOriginalSize,
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
