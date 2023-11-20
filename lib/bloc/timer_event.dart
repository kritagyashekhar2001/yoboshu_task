part of 'timer_bloc.dart';

@immutable
sealed class TimerEvent {}

class TimerStart extends TimerEvent {}

class TimerPause extends TimerEvent {}

class TimerReset extends TimerEvent {}
