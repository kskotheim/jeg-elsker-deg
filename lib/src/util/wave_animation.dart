import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations.dart';
import 'dart:math';

class AnimatedWave extends StatelessWidget {
  final double height;
  final double speed;
  final double offset;
  final Widget child;
  final bool top;
  final bool reverse;
  final int alpha;

  AnimatedWave(
      {this.height,
      this.speed,
      this.offset = 0.0,
      this.child,
      this.top = true,
      this.reverse = false,
      this.alpha = 40});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: constraints.biggest.width,
          child: LoopAnimation(
            child: child,
            duration: Duration(milliseconds: (5000 / speed).round()),
            tween: Tween(begin: 0.0, end: (reverse ? -2 : 2) * pi),
            builder: (context, child, value) {
              return CustomPaint(
                foregroundPainter: top
                    ? CurvePainter(value + offset, height, alpha: alpha)
                    : BottomCurvePainter(value + offset, height,
                        MediaQuery.of(context).size.height - height,
                        alpha: alpha),
                child: child,
              );
            },
          ),
        );
      },
    );
  }
}

class CurvePainter extends CustomPainter {
  final double value;
  final double height;
  final bool top;
  final int alpha;

  CurvePainter(this.value, this.height, {this.top = true, this.alpha = 40});

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withAlpha(alpha);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = height * (0.5 + 0.4 * y1);
    final controlPointY = height * (0.5 + 0.4 * y2);
    final endPointY = height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class BottomCurvePainter extends CustomPainter {
  final double value;
  final double height;
  final int alpha;
  final double verticalOffset;

  BottomCurvePainter(this.value, this.height, this.verticalOffset,
      {this.alpha = 40});

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withAlpha(alpha);
    final path = Path();

    final y1 = sin(value);
    final y2 = sin(value + pi / 2);
    final y3 = sin(value + pi);

    final startPointY = height * (0.5 + 0.4 * y1) + verticalOffset;
    final controlPointY = height * (0.5 + 0.4 * y2) + verticalOffset;
    final endPointY = height * (0.5 + 0.4 * y3) + verticalOffset;

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, height + verticalOffset);
    path.lineTo(0, height + verticalOffset);
    path.close();
    canvas.drawPath(path, white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PageOfWaves extends StatelessWidget {
  final Widget child;
  PageOfWaves({this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WaveBloc>(
      create: (context) => WaveBloc(),
      child: BlocBuilder<WaveBloc, List<double>>(
        builder: (context, waveVals) {
          return
              AnimatedSwitcher(
                              duration: const Duration(seconds: 1),
                              child: MyLoveWave(
                  waveFactor: waveVals[0],
            child: MyLoveWave(
                waveFactor: waveVals[1],
                child: MyLoveWave(
                  waveFactor: waveVals[2],
                  child: MyLoveWave(
                    waveFactor: waveVals[3],
                      child: child),
                ),
            ),
          ),
              );
        },
      ),
    );
  }
}

class MyLoveWave extends AnimatedWave {
  // takes a coded value "wave factor" and decodes it into a wave of certain position/direction/etc

  final double waveFactor;
  final Random random = Random();
  final Widget child;

  double waveSpeed;
  double waveHeight;
  double alphaVal;
  bool reverse;
  bool top;

  MyLoveWave({this.waveFactor = 0.0, this.child}) {
    double factorDecoded =
        waveFactor.abs() > 10 ? waveFactor.abs() - 10 : waveFactor.abs();
    waveSpeed = (random.nextDouble() + 1) / (factorDecoded * 8);
    waveHeight = factorDecoded / 3;
    top = waveFactor.abs() > 10;
    reverse = waveFactor > 0;
    alphaVal = 15 + ((1 - waveFactor) * 50);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedWave(
      height: waveHeight * MediaQuery.of(context).size.height,
      speed: waveSpeed,
      top: top,
      reverse: reverse,
      child: child,
    );
  }
}

class WaveBloc extends Bloc<WaveBlocEvent, List<double>> {
  // sets values for waves according to values stored in shared prefs
  // recieves new day events and calculates + stores new random wave values

  // positive / negative values indicate wave direction
  // absolute value greater than 10 indicates top wave
  // e.g. [-.3, .1, -10.5, 10.2] indicate bottom reverse, bottom forward, top reverse, and top forward waves
  // wave height, opacity, and speed are determined by the wave factor
  // (wave factor scales from 0 to 1)
  static const _NUMBER_OF_WAVES = 4;

  static const List<double> initialState = const [-.3, 10.45, -10.36, .75];
  static const _WAVE_FACTOR_KEY = 'Wave Factors';
  SharedPreferences prefs;
  final Random random = Random();

  WaveBloc() : super(initialState) {
    getState();
  }

  Future<void> getState() async {
    prefs = await SharedPreferences.getInstance();
    List<double> factors;
    try {
      factors = prefs
              .getStringList(_WAVE_FACTOR_KEY)
              .map((e) => double.parse(e)).toList() ??
          initialState;
    } catch (e) {
      factors = initialState;
    }
    add(LoadWaves(factors));
  }

  @override
  Stream<List<double>> mapEventToState(WaveBlocEvent event) async* {
    if (event is NewDayNewWaves) {
      // get wave factors
      List<double> newFactors = [];

      for (int i = 0; i < _NUMBER_OF_WAVES; i++) {
        double newVal = random.nextDouble();
        newVal += .2;
        newVal *= .8;
        if (random.nextBool()) {
          newVal += 10;
        }
        if (random.nextBool()) {
          newVal *= -1;
        }
        newFactors.add(newVal);
      }

      // save wave factors
      prefs.setStringList(
          _WAVE_FACTOR_KEY, newFactors.map((e) => e.toString()).toList());

      // yield new state
      yield newFactors;
    }
    if (event is LoadWaves) {
      yield event.waveFactors;
    }
  }
}

class WaveBlocEvent {}

class NewDayNewWaves extends WaveBlocEvent {}

class LoadWaves extends WaveBlocEvent {
  final List<double> waveFactors;
  LoadWaves(this.waveFactors) : assert(waveFactors != null);
}
