import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = '';
  GameState gameState = GameState.readyToStart;

  Timer? waitingTimer;
  Timer? stoppableTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282E3D),
      body: Stack(children: [
        Align(
            alignment: Alignment.center,
            child: Align(
              alignment: const Alignment(0, -0.8),
              child: Text(
                'Test your\nreaction speed',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            )),
        Align(
            alignment: Alignment.center,
            child: Align(
              alignment: Alignment.center,
              child: ColoredBox(
                color: Color(0xFF6D6D6D),
                child: SizedBox(
                  height: 160,
                  width: 300,
                  child: Center(
                    child: Text(
                      millisecondsText,
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            )),
        Align(
          alignment: Alignment.center,
          child: Align(
            alignment: Alignment(0, 0.8),
            child: GestureDetector(
              onTap: () => setState(() {
                switch (gameState) {
                  case GameState.readyToStart:
                    gameState = GameState.waiting;
                    millisecondsText = "";
                    _startWaitingTimer();
                    break;
                  case GameState.waiting:
                    break;
                  case GameState.canBeStopped:
                    gameState = GameState.readyToStart;
                    stoppableTimer?.cancel();
                    break;
                }
              }),
              child: ColoredBox(
                color: _colorsbox(),
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Center(
                    child: Text(
                      _getButtonText(),
                      style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return ('START');
      case GameState.waiting:
        return 'WAIT';
      case GameState.canBeStopped:
        return 'STOP';
    }
  }

  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;

    waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer();
    });
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = '${timer.tick * 16} ms';
      });
    });
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    super.dispose();
  }

  Color _colorsbox() {
    switch (gameState) {
      case GameState.readyToStart:
        return Color(0xFF40CA88);

      case GameState.waiting:
        return Color(0xFFE0982D);

      case GameState.canBeStopped:
        return Color(0xFFE02D47);
    }
  }
}

enum GameState { readyToStart, waiting, canBeStopped }
