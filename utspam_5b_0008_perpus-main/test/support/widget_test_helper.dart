import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Ukuran layar besar agar form scrollable tidak off-screen di test.
Future<void> setupLargeTestSurface(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Future<void> pumpAppWidget(
  WidgetTester tester,
  Widget home, {
  Duration settle = const Duration(milliseconds: 1200),
}) async {
  await setupLargeTestSurface(tester);
  await tester.pumpWidget(MaterialApp(home: home));
  await tester.pump(settle);
}

/// Hindari pumpAndSettle pada halaman dengan animasi tak berujung / Image.network.
Future<void> pumpFrames(
  WidgetTester tester, {
  int frames = 3,
  Duration step = const Duration(milliseconds: 400),
}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(step);
  }
}

Future<void> triggerFormValidation(WidgetTester tester) async {
  final formState = tester.state<FormState>(find.byType(Form));
  formState.validate();
  await tester.pump();
}

Future<void> tapWhenVisible(
  WidgetTester tester,
  Finder finder,
) async {
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await tester.pump(const Duration(milliseconds: 400));
}
