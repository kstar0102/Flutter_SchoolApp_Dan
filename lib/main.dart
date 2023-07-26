import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:recleatapp/src/app.dart';
import 'package:recleatapp/generated/assets.dart';

Future<void> main() async {
  setPathUrlStrategy();

  runApp(const ProviderScope(child: RecleatApp()));
}
