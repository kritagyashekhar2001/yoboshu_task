import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  int intialTime = 10;
  int pageIndex = 1;
  bool timerRunning = false;
  TimerBloc() : super(TimerInitial()) {
    on<TimerStart>((event, emit) async {
      timerRunning = true;
      Future.delayed(const Duration(seconds: 1), () {
        if (intialTime > 0 && timerRunning) {
          intialTime--;
          if (intialTime == 0) {
            add(TimerReset());
          } else {
            add(TimerStart());
          }
        }
      });
      emit(TimerStarted(remainingTime: intialTime));
    });
    on<TimerPause>((event, emit) {
      timerRunning = false;

      emit(TimerStarted(remainingTime: intialTime));
    });
    on<TimerReset>((event, emit) async {
      timerRunning = false;

      intialTime = 10;
      if (pageIndex == 3) {
        pageIndex = 1;
      } else {
        pageIndex++;
      }
      emit(TimerStopped());
    });
  }
}
