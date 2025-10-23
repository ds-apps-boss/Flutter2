import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

enum RunMode { stopwatch, timer }

class TimerController extends ChangeNotifier {
  RunMode mode = RunMode.stopwatch;

  final player = AudioPlayer();

  final Duration _tick = const Duration(milliseconds: 33);

  final Stopwatch _sw = Stopwatch();
  //Duration target = const Duration(minutes: 1);
  Duration target = const Duration(seconds: 3);

  bool _running = false;

  // ignore: unused_field
  Future<void>? _loop;

  bool get isRunning => _running;
  Duration get elapsed => _sw.elapsed;

  Duration get remaining {
    final left = target - _sw.elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  String get display {
    final Duration d = (mode == RunMode.stopwatch) ? elapsed : remaining;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final cc = (d.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(
      2,
      '0',
    );
    return '$m:$s$cc';
  }

  void setMode(RunMode newMode) {
    if (mode == newMode) return;
    stop();
    _sw.reset();
    mode = newMode;
    notifyListeners();
  }

  void setTarget(Duration d) {
    target = d;
    if (mode == RunMode.timer) notifyListeners();
  }

  void toggle() => _running ? stop() : start();

  void start() {
    if (_running) return;
    _running = true;
    _sw.start();
    notifyListeners();
    _loop = _runLoop();
  }

  void stop() {
    if (!_running) return;
    _running = false;
    _sw.stop();
    notifyListeners();
  }

  void reset() {
    stop();
    _sw.reset();
    notifyListeners();
  }

  Future<void> restart() async {
    _running = false;
    _sw.stop();
    _sw.reset();
    _running = true;
    _sw.start();
    _loop = _runLoop();
  }

  Future<void> _runLoop() async {
    while (_running) {
      if (mode == RunMode.timer && remaining == Duration.zero) {
        stop();
        notifyListeners();
        await _playAlarm();

        Future.delayed(const Duration(seconds: 2), () {
          _sw.reset();
          notifyListeners();
        });

        break;
      }
      notifyListeners();
      await Future.delayed(_tick);
    }
  }

  Future<void> _playAlarm() async {
    await player.play(AssetSource('sounds/alarm.wav'));
  }

  @override
  void dispose() {
    _running = false;
    super.dispose();
  }
}
