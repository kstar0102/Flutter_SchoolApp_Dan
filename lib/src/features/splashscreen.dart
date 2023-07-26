import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recleatapp/src/constants/app_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:recleatapp/src/routing/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recleatapp/src/widgets/dialogs.dart';
import 'package:recleatapp/src/widgets/progress_hud.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/gestures.dart';

const List<Color> _kDefaultRainbowColors = const [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  int _seconds = 2;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_seconds < 1) {
            timer.cancel();
            // SystemNavigator.pop();
            context.goNamed(AppRoute.loginScreen.name);
          } else {
            _seconds = _seconds - 1;
          }
        });
      },
    );
  }

  String get timerText {
    Duration duration = Duration(seconds: _seconds);
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        // inAsyncCall: state.isEmpty,
        child: SizedBox.expand(
          child: FocusScope(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 600.h),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 300,
                  ),
                  SizedBox(height: 800.h),
                  Center(
                      child: SizedBox(
                    height: 100,
                    width: 100,
                    child: LoadingIndicator(
                        indicatorType: Indicator.ballRotateChase,
                        colors: _kDefaultRainbowColors,
                        strokeWidth: 3.0),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
