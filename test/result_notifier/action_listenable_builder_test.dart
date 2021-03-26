import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';
import 'package:stated_result/stated_result_bloc.dart';
import 'package:stated_result/stated_result_listenable.dart';
import 'package:stated_result/stated_result_builder.dart';

import '../widget_tester/widget_tester.dart';

typedef Widget BuildWidget(ActionResultNotifier notifier);

void main() {
  group("ActionListenableBuilder", () {
    final error = "error";

    void runTestSet(BuildWidget buildWidget) {
      group("building ActionResultNotifier", () {
        testWidgets("omitted initial value", (WidgetTester tester) async {
          final notifier = ActionResultNotifier();

          await tester.pumpWidget(buildWidget(notifier));

          findPendingBeacon.shouldFindOne();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".pending", (WidgetTester tester) async {
          final notifier = ActionResultNotifier(AsyncActionResult.pending());

          await tester.pumpWidget(buildWidget(notifier));

          findPendingBeacon.shouldFindOne();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".waiting", (WidgetTester tester) async {
          final notifier = ActionResultNotifier(AsyncActionResult.waiting());

          await tester.pumpWidget(buildWidget(notifier));

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindOne();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".failed", (WidgetTester tester) async {
          final notifier = ActionResultNotifier(AsyncActionResult.failed(error));

          await tester.pumpWidget(buildWidget(notifier));

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon(error).shouldFindOne();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".completed", (WidgetTester tester) async {
          final notifier = ActionResultNotifier(AsyncActionResult.completed());

          await tester.pumpWidget(buildWidget(notifier));

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindOne();
        });
      });

      testWidgets("can be updated with succeeded", (WidgetTester tester) async {
        final notifier = ActionResultNotifier();

        await tester.pumpWidget(buildWidget(notifier));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer<ActionResult>();

        // ignore: unawaited_futures
        notifier.updateWith(completer.future);
        await tester.pump();

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        completer.complete(ActionResult.completed());
        await tester.pump(Duration.zero);

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindOne();
      });

      testWidgets("can be updated with failed", (WidgetTester tester) async {
        final notifier = ActionResultNotifier();

        await tester.pumpWidget(buildWidget(notifier));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer<ActionResult>();

        // ignore: unawaited_futures
        notifier.updateWith(completer.future);
        await tester.pump();

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        completer.complete(ActionResult.failed(error));
        await tester.pump(Duration.zero);

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon(error).shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("can capture future", (WidgetTester tester) async {
        final notifier = ActionResultNotifier();

        await tester.pumpWidget(buildWidget(notifier));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer();

        // ignore: unawaited_futures
        notifier.captureResult(completer.future);
        await tester.pump();

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        completer.complete();
        await tester.pump(Duration.zero);

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindOne();
      });

      testWidgets("can capture future with error", (WidgetTester tester) async {
        final notifier = ActionResultNotifier();

        await tester.pumpWidget(buildWidget(notifier));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer();

        // ignore: unawaited_futures
        notifier.captureResult(completer.future);
        await tester.pump();

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        completer.completeError(error);
        await tester.pump(Duration.zero);

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon(error).shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });
    }

    group("explicit builders", () {
      runTestSet((ActionResultNotifier notifier) => TestBench(
        child: ActionListenableBuilder(
          listenable: notifier,
          pendingBuilder: (_) => PendingBeacon(),
          waitingBuilder: (_) => WaitingBeacon(),
          failedBuilder: (_, result) => ErrorBeacon(result.error),
          builder: (BuildContext context) => ContentBeacon(),
        ),
      ));
    });

    group("default builders", () {
      runTestSet((ActionResultNotifier notifier) => TestBench(
        child: DefaultResultBuilder(
          pendingBuilder: (_) => PendingBeacon(),
          waitingBuilder: (_) => WaitingBeacon(),
          failedBuilder: (_, result) => ErrorBeacon(result.error),
          child: ActionListenableBuilder(
            listenable: notifier,
            builder: (BuildContext context) => ContentBeacon(),
          ),
        ),
      ));
    });

    group("global default builders", () {
      setUp(() {
        DefaultResultBuilder.setGlobalBuilder(
          pendingBuilder: (_) => PendingBeacon(),
          waitingBuilder: (_) => WaitingBeacon(),
          failedBuilder: (_, errorInfo) => ErrorBeacon(errorInfo.error),
        );
      });

      tearDown(() {
        DefaultPendingResultBuilder.setGlobalBuilder(null);
        DefaultWaitingResultBuilder.setGlobalBuilder(null);
        DefaultFailedResultBuilder.setGlobalBuilder(null);
      });

      runTestSet((ActionResultNotifier notifier) => TestBench(
        child: ActionListenableBuilder(
          listenable: notifier,
          builder: (BuildContext context) => ContentBeacon(),
        ),
      ));
    });
  });
}
