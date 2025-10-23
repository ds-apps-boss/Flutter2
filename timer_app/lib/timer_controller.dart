// timer_controller.dart
import 'dart:async';
import 'package:flutter/foundation.dart';

enum RunMode { stopwatch, timer }

class TimerController extends ChangeNotifier {
  RunMode mode = RunMode.stopwatch;

  // Точность обновления UI
  final Duration _tick = const Duration(milliseconds: 33); // ~30 FPS

  // Бизнес-время
  final Stopwatch _sw = Stopwatch(); // точное измерение прошедшего
  Duration target = const Duration(minutes: 1); // цель для таймера

  // Вспомогательные
  bool _running = false;
  Future<void>? _loop;

  bool get isRunning => _running;
  Duration get elapsed => _sw.elapsed;

  Duration get remaining {
    final left = target - _sw.elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  /// Текст в формате MM:SScc (cc — сотые)
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
    // асинхронный «тикер» на await Future.delayed
    while (_running) {
      // автостоп для таймера
      if (mode == RunMode.timer && remaining == Duration.zero) {
        stop();
        notifyListeners(); // финальный апдейт на 00:00
        break;
      }
      notifyListeners();
      await Future.delayed(_tick);
    }
  }

  @override
  void dispose() {
    _running = false; // завершит цикл
    super.dispose();
  }
}
