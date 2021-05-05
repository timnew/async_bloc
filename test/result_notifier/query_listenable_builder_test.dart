import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';
import 'package:stated_result/stated_result_listenable.dart';
import 'package:stated_result/stated_result_builder.dart';
import 'package:test_beacon/test_beacon.dart';

import '../widget_tester/custom_matchers.dart';
import '../widget_tester/widget_tester.dart';

typedef Widget BuildWidget(QueryResultNotifier<String> bloc);

void main() {
  group("QueryListenableBuilder", () {
    final error = "error";
    final value = "value";

    void runTestSet(BuildWidget buildWidget) {
      group("building AsyncQueryResult", () {
        testWidgets("omitted", (WidgetTester tester) async {
          final notifier = QueryResultNotifier<String>();

          await tester.pumpWidgetOnScaffold(buildWidget(notifier));

          findPendingBeacon.shouldFindOne();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".pending", (WidgetTester tester) async {
          final notifier =
              QueryResultNotifier<String>(AsyncQueryResult<String>.pending());

          await tester.pumpWidgetOnScaffold(buildWidget(notifier));

          findPendingBeacon.shouldFindOne();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".waiting", (WidgetTester tester) async {
          final notifier =
              QueryResultNotifier<String>(AsyncQueryResult<String>.waiting());

          await tester.pumpWidgetOnScaffold(buildWidget(notifier));

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindOne();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".failed", (WidgetTester tester) async {
          final notifier = QueryResultNotifier<String>(
              AsyncQueryResult<String>.failed(error));

          await tester.pumpWidgetOnScaffold(buildWidget(notifier));

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon(error).shouldFindOne();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".succeeded", (WidgetTester tester) async {
          final notifier = QueryResultNotifier<String>(
              AsyncQueryResult<String>.succeeded(value));

          await tester.pumpWidgetOnScaffold(buildWidget(notifier));

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon(value).shouldFindOne();
        });
      });

      testWidgets("can be updated with succeeded", (WidgetTester tester) async {
        final notifier = QueryResultNotifier<String>();

        await tester.pumpWidgetOnScaffold(buildWidget(notifier));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer<QueryResult<String>>();

        final updatedResult = notifier.updateWith(completer.future);
        await tester.pump();

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        completer.complete(QueryResult<String>.succeeded(value));
        await tester.pump(Duration.zero);
        await expectLater(
          updatedResult,
          completion(QueryResult<String>.succeeded(value)),
        );

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon(value).shouldFindOne();
      });

      testWidgets("can be updated with failed", (WidgetTester tester) async {
        final notifier = QueryResultNotifier<String>();

        await tester.pumpWidgetOnScaffold(buildWidget(notifier));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer<QueryResult<String>>();

        final updatedResult = notifier.updateWith(completer.future);
        await tester.pump();

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        completer.complete(QueryResult<String>.failed(error));
        await tester.pump(Duration.zero);
        await expectLater(
          updatedResult,
          completion(WithError(equals(error))),
        );

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon(error).shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("can capture future", (WidgetTester tester) async {
        final notifier = QueryResultNotifier<String>();

        await tester.pumpWidgetOnScaffold(buildWidget(notifier));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer<String>();

        final capturedResult = notifier.captureResult(completer.future);
        await tester.pump();

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        completer.complete(value);
        await tester.pump(Duration.zero);
        await expectLater(
          capturedResult,
          completion(QueryResult<String>.succeeded(value)),
        );

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon(value).shouldFindOne();
      });

      testWidgets("can capture future with error", (WidgetTester tester) async {
        final notifier = QueryResultNotifier<String>();

        await tester.pumpWidgetOnScaffold(buildWidget(notifier));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer<String>();

        final capturedResult = notifier.captureResult(completer.future);
        await tester.pump();

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        completer.completeError(error);
        await tester.pump(Duration.zero);
        await expectLater(
          capturedResult,
          completion(WithError(equals(error))),
        );

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon(error).shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });
    }

    group("explicit builders", () {
      runTestSet((QueryResultNotifier<String> notifier) =>
          QueryListenableBuilder<String>(
            listenable: notifier,
            pendingBuilder: (_) => PendingBeacon(),
            waitingBuilder: (_) => WaitingBeacon(),
            failedBuilder: (_, result) => ErrorBeacon(result.error),
            builder: (_, value) => ContentBeacon(value),
          ));
    });

    group("default builders", () {
      runTestSet((QueryResultNotifier<String> notifier) => DefaultResultBuilder(
            pendingBuilder: (_) => PendingBeacon(),
            waitingBuilder: (_) => WaitingBeacon(),
            failedBuilder: (_, result) => ErrorBeacon(result.error),
            child: QueryListenableBuilder<String>(
              listenable: notifier,
              builder: (_, value) => ContentBeacon(value),
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

      runTestSet((QueryResultNotifier<String> notifier) =>
          QueryListenableBuilder<String>(
            listenable: notifier,
            builder: (_, value) => ContentBeacon(value),
          ));
    });
  });
}
