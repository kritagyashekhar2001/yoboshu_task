part of 'timer_bloc.dart';

@immutable
sealed class TimerState {}

final class TimerInitial extends TimerState {}

class TimerStarted extends TimerState {
  final int remainingTime;

  TimerStarted({required this.remainingTime});
}

class TimerStopped extends TimerState {}
