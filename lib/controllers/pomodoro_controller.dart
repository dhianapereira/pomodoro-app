import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:pomodoro/core/interval_type_enum.dart';
import 'package:pomodoro/core/status_enum.dart';
part 'pomodoro_controller.g.dart';

class PomodoroController = _PomodoroControllerBase with _$PomodoroController;

abstract class _PomodoroControllerBase with Store {
  Timer? stopwatch;

  @observable
  Status status = Status.initial;

  @observable
  int minutes = 2;

  @observable
  int seconds = 0;

  @observable
  int workingTime = 2;

  @observable
  int restTime = 1;

  @observable
  IntervalType intervalType = IntervalType.work;

  @computed
  String get time {
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  bool get isWorking => intervalType == IntervalType.work;

  bool get isResting => intervalType == IntervalType.rest;

  bool get wasStarted => status == Status.started;

  bool get wasStopped => status == Status.stopped;

  @action
  void start() {
    status = Status.started;

    stopwatch = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (minutes == 0 && seconds == 0) {
        _changeIntervalType();
      } else if (seconds == 0) {
        seconds = 59;
        minutes--;
      } else {
        seconds--;
      }
    });
  }

  @action
  void stop() {
    status = Status.stopped;

    stopwatch?.cancel();
  }

  @action
  void restart() {
    status = Status.initial;
  }

  @action
  void incrementWorkingTime() => workingTime++;

  @action
  void decrementWorkingTime() => workingTime--;

  @action
  void incrementRestTime() => restTime++;

  @action
  void decrementRestTime() => restTime--;

  void _changeIntervalType() {
    if (isWorking) {
      intervalType = IntervalType.rest;
      minutes = restTime;
    } else {
      intervalType = IntervalType.work;
      minutes = workingTime;
    }

    seconds = 0;
  }
}