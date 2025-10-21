import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
//import 'package:google_fonts/google_fonts.dart';

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

  /*
  Widget build() {
    return Align(
      alignment: pPos,
      child: SizedBox(
        width: newSize.width,
        height: newSize.height,
        child: image,
      ),
    );
  }
  */
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
    await player.play(AssetSource('sounds/01.mp3'));
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

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //appBar:Title(title: "TimerApp",),
        body: Center(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 80),

              child: LayoutBuilder(
                builder: (context, constraints) {
                  final side = (constraints.maxHeight > constraints.maxWidth)
                      ? constraints.maxWidth
                      : constraints.maxHeight;

                  //pic: width=3001, height=3001
                  final timerSize = Size(3001, 3001);
                  final topButtonSize = Size(336, 82);
                  final leftButtonSize = Size(365, 342);
                  final rightButtonSize = Size(360, 342);

                  final newSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  final aspectX = newSize.width / timerSize.width;
                  final aspectY = newSize.height / timerSize.height;

                  final leftButton = TimerButtonData(
                    name: 'leftButton',
                    pPos: Alignment(-0.6, -0.82),
                    aPos: Alignment(-0.56, -0.78),
                    //fileOriginalSize: Size(365, 342),
                    newSize: Size(
                      leftButtonSize.width * aspectX,
                      leftButtonSize.height * aspectY,
                    ),
                    image: Image.asset("assets/images/button_left.png"),
                    onTap: () {},
                  );

                  final rightButton = TimerButtonData(
                    name: 'leftButton',
                    pPos: Alignment(0.65, -0.8),
                    aPos: Alignment(0.6, -0.78),
                    //fileOriginalSize: Size(360, 342),
                    newSize: Size(
                      rightButtonSize.width * aspectX,
                      rightButtonSize.height * aspectY,
                    ),
                    image: Image.asset("assets/images/button_right.png"),
                    onTap: () {},
                  );

                  final topButton = TimerButtonData(
                    name: 'topButton',
                    pPos: Alignment(0.02, -0.84),
                    aPos: Alignment(0.02, -0.8),
                    //fileOriginalSize: Size(360, 342),
                    newSize: Size(
                      topButtonSize.width * aspectX,
                      topButtonSize.height * aspectY,
                    ),
                    image: Image.asset("assets/images/button_top.png"),
                    onTap: () {},
                  );

                  /*
                  Future timerPicSize;

                  void testSize() async {
                    final size = await getAssetImageSize('assets/images/stoppuhr_wob.png');
                    timerPicSize = Size(size.width, size.height);
                    //print('Размер картинки: ${size.width} x ${size.height}');
                  }
*/

                  return Center(
                    child: SizedBox.square(
                      dimension: side,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          //stoppuhr
                          const Positioned.fill(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Image(
                                image: AssetImage(
                                  "assets/images/stoppuhr_wob2.png",
                                ),
                              ),
                            ),
                          ),

                          //button left
                          TimerButton(data: leftButton),

                          //button top
                          TimerButton(data: topButton),

                          //button right
                          TimerButton(data: rightButton),

                          Align(
                            alignment: Alignment(0.01, -0.02),
                            child: FractionallySizedBox(
                              widthFactor: 0.37,
                              alignment: Alignment.centerRight,
                              child: Text(
                                "88:86",
                                style: TextStyle(
                                  fontFamily: 'Digital7',
                                  fontSize: 76,
                                  color: Color.fromARGB(180, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<Size> getAssetImageSize(String assetPath) async {
  final completer = Completer<Size>();
  final provider = AssetImage(assetPath);
  final stream = provider.resolve(const ImageConfiguration());

  ImageStreamListener? listener;

  listener = ImageStreamListener((ImageInfo info, bool _) {
    final myImage = info.image;
    completer.complete(
      Size(myImage.width.toDouble(), myImage.height.toDouble()),
    );
    stream.removeListener(listener!); // снять слушатель
  });

  stream.addListener(listener);

  return completer.future;
}
