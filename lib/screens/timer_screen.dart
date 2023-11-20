import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoboshu_task/bloc/timer_bloc.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late AudioPlayer _audioPlayer;
  // to play sounds
  _playSound() async {
    await _audioPlayer.play(AssetSource('sound/countdown_tick.wav'));
  }

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = BlocProvider.of<TimerBloc>(context).pageIndex - 1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.teal[800],
      appBar: AppBar(
        title: const Text('Mindful Meal timer'),
        backgroundColor: Colors.teal[900],
      ),
      body: Center(
        child: BlocConsumer<TimerBloc, TimerState>(
          listener: (context, state) {
            if (state is TimerStarted && state.remainingTime <= 4) {
              _playSound();
            }
            if (state is TimerStopped) {
              _tabController.index =
                  BlocProvider.of<TimerBloc>(context).pageIndex - 1;
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: TabPageSelector(
                    indicatorSize: 10,
                    borderStyle: BorderStyle.none,
                    color: Colors.grey,
                    selectedColor: Colors.white,
                    controller: _tabController,
                  ),
                ),
                if (BlocProvider.of<TimerBloc>(context).pageIndex == 1)
                  Text(
                    state is TimerStarted
                        ? 'Nom Nom:)'
                        : 'Time to eat mindfully',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.03,
                        fontWeight: FontWeight.w500),
                  )
                else if (BlocProvider.of<TimerBloc>(context).pageIndex == 2)
                  Text(
                    'Break Time',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.03,
                        fontWeight: FontWeight.w500),
                  )
                else
                  Text(
                    'Finish your Meal',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.03,
                        fontWeight: FontWeight.w500),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: Text(
                    'It is simple : eat slowly for ten minutes, rest for five, then finish your meal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.02,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.07),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(width * 0.03),
                        child: SizedBox(
                          height: width * 0.55,
                          width: width * 0.55,
                          child: CircularProgressIndicator(
                            color: Colors.teal[900],
                            value:
                                BlocProvider.of<TimerBloc>(context).intialTime /
                                    10,
                            strokeWidth: 25,
                          ),
                        ),
                      ),
                      Positioned(
                        child: Column(
                          children: [
                            Text(
                              "00:${BlocProvider.of<TimerBloc>(context).intialTime.toString().padLeft(2, '0')}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: height * 0.05,
                                  fontWeight: FontWeight.w800),
                            ),
                            Text(
                              "seconds remaining",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: height * 0.015,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if (state is TimerStarted)
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (BlocProvider.of<TimerBloc>(context)
                                .timerRunning) {
                              BlocProvider.of<TimerBloc>(context)
                                  .add(TimerPause());
                            } else {
                              BlocProvider.of<TimerBloc>(context)
                                  .add(TimerStart());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.green[200]),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: height * .02,
                                horizontal: width * 0.2),
                            child: Text(
                              BlocProvider.of<TimerBloc>(context).timerRunning
                                  ? 'PAUSE'
                                  : "RESUME",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: height * 0.02,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        if (BlocProvider.of<TimerBloc>(context).pageIndex != 2)
                          ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<TimerBloc>(context)
                                  .add(TimerReset());
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: Colors.green[200]),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * .02,
                                  horizontal: width * 0.2),
                              child: Text(
                                'I AM FULL,STOP',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: height * 0.02,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<TimerBloc>(context).add(TimerStart());
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.green[200]),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * .02, horizontal: width * 0.2),
                      child: Text('START',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: height * 0.02,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
