import 'package:flutter/material.dart';
import 'dart:async';
import 'package:timer_app/timer_button.dart';
import 'package:timer_app/lcd_text_element.dart';
import 'package:timer_app/bottom_toolbar.dart';
import 'package:timer_app/timer_controller.dart';
import 'package:timer_app/beeper.dart';
import 'package:timer_app/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainAppState();
}

class _MainAppState extends State<MainScreen> {
  final TimerController clock = TimerController();
  //clock.setMode(clock.mode.stopwatch);

  bool isRunning = false;
  RunMode mode = RunMode.stopwatch;

  //bool _advancedMode = false;

  Future<void> _openSettings() async {
    await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      barrierColor: const Color.fromARGB(128, 0, 0, 0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SettingsSheet(
        initial: clock.target,
        onSave: (d) {
          clock.setTarget(d);
          if (clock.mode == RunMode.timer) {
            clock.reset();
          }
        },
      ),
    );
  }

  void _toggleRun() => clock.toggle();

  void _switchMode() => setState(() {
    mode = (mode == RunMode.stopwatch) ? RunMode.timer : RunMode.stopwatch;
    clock.setMode(mode);
  });

  void _reset() {
    if (clock.isRunning) {
      clock.restart();
    } else {
      clock.reset();
    }
  }

  @override
  void initState() {
    super.initState();
    clock.setMode(RunMode.stopwatch);
    clock.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        top: false,
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

            final leftButton = TimerButtonData(
              name: 'leftButton',
              pPos: Alignment(-0.61, -0.744),
              aPos: Alignment(-0.57, -0.7),
              newSize: Size(
                leftButtonSize.width * scale,
                leftButtonSize.height * scale,
              ),
              image: Image.asset("assets/images/button_left.png"),
              onTap: () {
                _reset();
              },
            );

            final rightButton = TimerButtonData(
              name: 'leftButton',
              pPos: Alignment(0.64, -0.74),
              aPos: Alignment(0.6, -0.7),
              newSize: Size(
                rightButtonSize.width * scale,
                rightButtonSize.height * scale,
              ),
              image: Image.asset("assets/images/button_right.png"),
              onTap: () {
                clock.toggle();
              },
            );

            final topButton = TimerButtonData(
              name: 'topButton',
              pPos: Alignment(0.02, -0.827),
              aPos: Alignment(0.02, -0.782),
              newSize: Size(
                topButtonSize.width * scale,
                topButtonSize.height * scale,
              ),
              image: Image.asset("assets/images/button_top.png"),
              onTap: () {
                _switchMode();
              },
            );

            final isTimer = (mode == RunMode.timer);

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
                          image: AssetImage("assets/images/stoppuhr_wob2.png"),
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
                      showedText: clock.display.substring(0, 5),
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
                      top: side * 0.5,
                      showedText: clock.display.substring(5),
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
                      left: isTimer ? side * 0.25 : side * 0.43,
                      top: side * 0.39,
                      showedText: isTimer ? 'TIMER' : 'STOPWATCH',
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

                    BeepBurstOverlay(
                      asset: 'assets/images/beep.png',
                      show:
                          (isTimer &&
                          !clock.isRunning &&
                          clock.remaining == Duration.zero),
                      onDone: () {},
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // ),
      ),

      bottomNavigationBar: BottomToolBar(
        isRunning: clock.isRunning,
        mode: clock.mode,
        onToggleRun: _toggleRun,
        onSwitchMode: _switchMode,
        onReset: _reset,
        onOpenSettings: _openSettings,
      ),
      // ),
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
