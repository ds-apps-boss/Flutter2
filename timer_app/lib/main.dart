import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

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
        appBar: AppBar(
          title: Text("TimerApp"),
          backgroundColor: Color.fromARGB(0, 255, 255, 0),
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 125, 130, 104),
                  Color.fromARGB(255, 168, 173, 144),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        body: SafeArea(
          //child: Padding(
          //padding: EdgeInsets.fromLTRB(0, 20, 0, 80),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final side = (constraints.maxHeight > constraints.maxWidth)
                  ? constraints.maxWidth
                  : constraints.maxHeight;

              //pic: width=3001, height=3001 ........ quadratisch
              final timerFileSizeSide = 3001.0;
              final topButtonSize = Size(336, 82);
              final leftButtonSize = Size(365, 342);
              final rightButtonSize = Size(360, 342);

              final scale = side / timerFileSizeSide;
              /*
                final newSize = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                */
              //final aspectX = newSize.width / timerSize.width;
              //final aspectY = newSize.height / timerSize.height;

              final leftButton = TimerButtonData(
                name: 'leftButton',
                pPos: Alignment(-0.61, -0.744),
                aPos: Alignment(-0.57, -0.7),
                //fileOriginalSize: Size(365, 342),
                newSize: Size(
                  leftButtonSize.width * scale,
                  leftButtonSize.height * scale,
                ),
                image: Image.asset("assets/images/button_left.png"),
                onTap: () {},
              );

              final rightButton = TimerButtonData(
                name: 'leftButton',
                pPos: Alignment(0.64, -0.74),
                aPos: Alignment(0.6, -0.7),
                //fileOriginalSize: Size(360, 342),
                newSize: Size(
                  rightButtonSize.width * scale,
                  rightButtonSize.height * scale,
                ),
                image: Image.asset("assets/images/button_right.png"),
                onTap: () {},
              );

              final topButton = TimerButtonData(
                name: 'topButton',
                pPos: Alignment(0.02, -0.827),
                aPos: Alignment(0.02, -0.782),
                //fileOriginalSize: Size(360, 342),
                newSize: Size(
                  topButtonSize.width * scale,
                  topButtonSize.height * scale,
                ),
                image: Image.asset("assets/images/button_top.png"),
                onTap: () {},
              );

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

                      /*
                      Positioned(
                        left: side * 0.325,
                        top: side * 0.407,
                        width: side * 0.355,
                        height: side * 0.18,
                        child:
                            //test
                            
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(80, 255, 255, 0),
                                border: Border.all(color: Colors.red, width: 1),
                              ),
                              child: 
                            FittedBox(
                              fit: BoxFit
                                  .contain, // подгонит текст по высоте/ширине окна
                              alignment: Alignment
                                  .centerRight, // как у настоящих часов — выравниваем справа
                              child: Text(
                                '03:47',
                                textAlign: TextAlign.right,
                                textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false,
                                  applyHeightToLastDescent: false,
                                ),
                                strutStyle: const StrutStyle(
                                  forceStrutHeight: true,
                                  height: 1.0,
                                  leading: 0.0,
                                  fontSize:
                                      100, // любое — FittedBox всё равно подгонит
                                  //fontFamily: 'Digital7',
                                ),
                                style: const TextStyle(
                                  //fontFamily: 'DSEGClassicMini',
                                  fontFamily: 'SevenSegment',
                                  //fontWeight: FontWeight.w700,
                                  fontSize:
                                      100, // любое — масштабирует FittedBox
                                  height: 1.0, // плотнее по вертикали
                                  letterSpacing:
                                      -2, // чуть сжать по горизонтали (опционально)
                                  color: Color.fromARGB(200, 0, 0, 0),
                                  // fontFeatures: [FontFeature.tabularFigures()], // если шрифт поддерживает
                                ),
                                  ),
                              ),
                            ),
*/

                      //           ),
                      LCDTextElement(
                        width: side * 0.27,
                        height: side * 0.22,
                        left: side * 0.325,
                        top: side * 0.42,
                        showedText: '80:59',
                        debug: false,
                        style: const TextStyle(
                          fontFamily: 'DSEGClassicMini',
                          fontWeight: FontWeight.w700,
                          fontSize: 100,
                          height: 1.0,
                          letterSpacing: -2,
                          color: Color.fromARGB(200, 0, 0, 0),
                        ),
                      ).build(),

                      LCDTextElement(
                        width: side * 0.085,
                        height: side * 0.08,
                        left: side * 0.6,
                        top: side * 0.49,
                        showedText: '00',
                        debug: false,
                        style: const TextStyle(
                          fontFamily: 'DSEGClassicMini',
                          fontWeight: FontWeight.w700,
                          fontSize: 100,
                          height: 1.0,
                          letterSpacing: -2,
                          color: Color.fromARGB(200, 0, 0, 0),
                        ),
                      ).build(),

                      LCDTextElement(
                        width: side * 0.15,
                        height: side * 0.035,
                        left: side * 0.45,
                        top: side * 0.39,
                        showedText: 'STOPWATCH',
                        debug: false,
                      ).build(),

                      LCDTextElement(
                        width: side * 0.1,
                        height: side * 0.035,
                        left: side * 0.58,
                        top: side * 0.39,
                        showedText: '1/100',
                        debug: false,
                      ).build(),
                    ],
                  ),
                ),
              );
            },
          ),
          // ),
        ),

        bottomNavigationBar: BottomAppBar(
          elevation: 2,
          // child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 168, 173, 144),
                  Color.fromARGB(255, 125, 130, 104),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),

            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(children: [Text("123"), Text("456")]),
            ),
          ),
          //  ),
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
    stream.removeListener(listener!);
  });

  stream.addListener(listener);

  return completer.future;
}

class LCDTextElement {
  final double left;
  final double top;
  final double width;
  final double height;
  final String showedText;
  final bool debug;
  final TextStyle? style;

  LCDTextElement({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.showedText,
    this.debug = false,
    this.style,
  });

  Widget build() {
    Widget debugWrap(Widget child) {
      if (!debug) return child;
      return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(80, 255, 255, 0),
          border: Border.all(color: Colors.red, width: 1),
        ),
        child: child,
      );
    }

    TextStyle defaultStyle = GoogleFonts.robotoCondensed(
      fontWeight: FontWeight.w800,
      fontSize: 72,
      letterSpacing: -2,
      color: Colors.black,
    );

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: debugWrap(
        FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
          child: Text(
            showedText,
            textAlign: TextAlign.right,
            textHeightBehavior: TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
            strutStyle: const StrutStyle(
              forceStrutHeight: true,
              height: 1.0,
              leading: 0.0,
              fontSize: 100,
            ),
            style: style ?? defaultStyle,
          ),
        ),
      ),
    );
  }
}
