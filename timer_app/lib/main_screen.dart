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

  late final TimerButtonController leftCtrl;
  late final TimerButtonController topCtrl;
  late final TimerButtonController rightCtrl;

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

  void _reset() async {
    if (clock.isRunning) {
      await clock.restart();
    } else {
      await clock.reset();
    }
  }

  @override
  void initState() {
    super.initState();
    leftCtrl = TimerButtonController();
    topCtrl = TimerButtonController();
    rightCtrl = TimerButtonController();
    clock.setMode(RunMode.stopwatch);
    clock.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    leftCtrl.dispose();
    topCtrl.dispose();
    rightCtrl.dispose();
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

            final isTimer = (mode == RunMode.timer);

            final leftSpec = TimerButtonSpec(
              id: ButtonId.left,
              pPos: const Alignment(-0.61, -0.744),
              aPos: const Alignment(-0.57, -0.70),
              size: Size(
                leftButtonSize.width * scale,
                leftButtonSize.height * scale,
              ),
              onTap: _reset,
            );

            final topSpec = TimerButtonSpec(
              id: ButtonId.top,
              pPos: const Alignment(0.02, -0.827),
              aPos: const Alignment(0.02, -0.782),
              size: Size(
                topButtonSize.width * scale,
                topButtonSize.height * scale,
              ),
              onTap: _switchMode,
            );

            final rightSpec = TimerButtonSpec(
              id: ButtonId.right,
              pPos: const Alignment(0.64, -0.74),
              aPos: const Alignment(0.60, -0.70),
              size: Size(
                rightButtonSize.width * scale,
                rightButtonSize.height * scale,
              ),
              onTap: _toggleRun,
            );

            return Center(
              child: SizedBox.square(
                dimension: side,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    //button left
                    //TimerButton(data: leftButton),
                    VisibleButton(
                      spec: leftSpec,
                      controller: leftCtrl,
                      image: Image.asset("assets/images/button_left.png"),
                    ),

                    //button top
                    //TimerButton(data: topButton),
                    VisibleButton(
                      spec: topSpec,
                      controller: topCtrl,
                      image: Image.asset("assets/images/button_top.png"),
                    ),

                    //button right
                    // TimerButton(data: rightButton),
                    VisibleButton(
                      spec: rightSpec,
                      controller: rightCtrl,
                      image: Image.asset("assets/images/button_right.png"),
                    ),

                    //stoppuhr
                    const Positioned.fill(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image(
                          image: AssetImage("assets/images/stoppuhr_wob2.png"),
                        ),
                      ),
                    ),

                    InvisibleButton(spec: leftSpec, controller: leftCtrl),
                    InvisibleButton(spec: topSpec, controller: topCtrl),
                    InvisibleButton(spec: rightSpec, controller: rightCtrl),

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

                    ColonBlink(
                      clock: clock,
                      left: side * 0.454,
                      top: side * 0.48,
                      width: side * 0.014,
                      height: side * 0.07,
                      color: Color.fromARGB(255, 156, 161, 130),
                    ),

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
      ),

      bottomNavigationBar: BottomToolBar(
        isRunning: clock.isRunning,
        mode: clock.mode,
        onToggleRun: _toggleRun,
        onSwitchMode: _switchMode,
        onReset: _reset,
        onOpenSettings: _openSettings,
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

class ColonBlink extends StatelessWidget {
  const ColonBlink({
    super.key,
    required this.clock,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    this.fade = const Duration(milliseconds: 120),
    this.color = const Color.fromARGB(199, 202, 189, 8),
  });

  final TimerController clock;
  final double left, top, width, height;
  final Duration fade;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: clock,
      builder: (_, __) {
        final ms = clock.elapsed.inMilliseconds % 1000;
        final bool hide = clock.isRunning && ms >= 500;
        return Positioned(
          left: left,
          top: top,
          width: width,
          height: height,
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: hide ? 1 : 0,
              duration: fade,
              child: Container(color: color),
            ),
          ),
        );
      },
    );
  }
}
