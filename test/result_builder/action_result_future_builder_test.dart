import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result_builder.dart';

import '../widget_tester/widget_tester.dart';

typedef Widget BuildWidget(Future? future);

void main() {
  group("ActionResultFutureBuilder", () {
    final error = "error";

    void runTestSet(BuildWidget buildWidget) {
      testWidgets("should build success", (WidgetTester tester) async {
        final completer = Completer();

        await tester.pumpWidget(buildWidget(completer.future));

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        completer.complete(null);

        await tester.pump();

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindOne();
      });

      testWidgets("should build failed", (WidgetTester tester) async {
        final completer = Completer();

        await tester.pumpWidget(buildWidget(completer.future));

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        completer.completeError(error);

        await tester.pump();

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon(error).shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("should build null", (WidgetTester tester) async {
        await tester.pumpWidget(buildWidget(null));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();
      });
    }

    group("explicit builders", () {
      runTestSet((Future? future) => TestBench(
            child: ActionResultFutureBuilder.fromFuture(
              future: future,
              pendingBuilder: (_) => PendingBeacon(),
              waitingBuilder: (_) => WaitingBeacon(),
              failedBuilder: (_, result) => ErrorBeacon(result.error),
              builder: (BuildContext context) => ContentBeacon(),
            ),
          ));
    });

    group("default builders", () {
      runTestSet((Future? future) => TestBench(
            child: DefaultResultBuilder(
              pendingBuilder: (_) => PendingBeacon(),
              waitingBuilder: (_) => WaitingBeacon(),
              failedBuilder: (_, result) => ErrorBeacon(result.error),
              child: ActionResultFutureBuilder.fromFuture(
                future: future,
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

      runTestSet((Future? future) => TestBench(
            child: ActionResultFutureBuilder.fromFuture(
              future: future,
              builder: (BuildContext context) => ContentBeacon(),
            ),
          ));
    });
  });
}
