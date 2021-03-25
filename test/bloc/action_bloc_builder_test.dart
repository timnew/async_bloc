import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';
import 'package:stated_result/stated_result_bloc.dart';
import 'package:stated_result/stated_result_builder.dart';

import '../widget_tester/widget_tester.dart';

typedef Widget BuildWidget(ActionCubit bloc);

void main() {
  group("ActionBlocBuilder", () {
    final error = "error";

    void runTestSet(BuildWidget buildWidget) {
      group("building AsyncActionResult", () {
        testWidgets(".pending", (WidgetTester tester) async {
          final cubit = ActionCubit(AsyncActionResult.pending());

          await tester.pumpWidget(buildWidget(cubit));

          findPendingBeacon.shouldFindOne();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".waiting", (WidgetTester tester) async {
          final cubit = ActionCubit(AsyncActionResult.waiting());

          await tester.pumpWidget(buildWidget(cubit));

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindOne();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".failed", (WidgetTester tester) async {
          final cubit = ActionCubit(AsyncActionResult.failed(error));

          await tester.pumpWidget(buildWidget(cubit));

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon(error).shouldFindOne();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".completed", (WidgetTester tester) async {
          final cubit = ActionCubit(AsyncActionResult.completed());

          await tester.pumpWidget(buildWidget(cubit));

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindOne();
        });
      });

      testWidgets("can be updated with succeeded", (WidgetTester tester) async {
        final cubit = ActionCubit();

        await tester.pumpWidget(buildWidget(cubit));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer<ActionResult>();

        // ignore: unawaited_futures
        cubit.updateWith(completer.future);
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
        final cubit = ActionCubit();

        await tester.pumpWidget(buildWidget(cubit));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer<ActionResult>();

        // ignore: unawaited_futures
        cubit.updateWith(completer.future);
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
        final cubit = ActionCubit();

        await tester.pumpWidget(buildWidget(cubit));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer();

        // ignore: unawaited_futures
        cubit.captureResult(completer.future);
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
        final cubit = ActionCubit();

        await tester.pumpWidget(buildWidget(cubit));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer();

        // ignore: unawaited_futures
        cubit.captureResult(completer.future);
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
      runTestSet((ActionCubit bloc) => TestBench(
            child: ActionBlocBuilder(
              bloc: bloc,
              pendingBuilder: (_) => PendingBeacon(),
              waitingBuilder: (_) => WaitingBeacon(),
              failedBuilder: (_, result) => ErrorBeacon(result.error),
              builder: (BuildContext context) => ContentBeacon(),
            ),
          ));
    });

    group("default builders", () {
      runTestSet((ActionCubit bloc) => TestBench(
            child: DefaultResultBuilder(
              pendingBuilder: (_) => PendingBeacon(),
              waitingBuilder: (_) => WaitingBeacon(),
              failedBuilder: (_, result) => ErrorBeacon(result.error),
              child: ActionBlocBuilder(
                bloc: bloc,
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

      runTestSet((ActionCubit bloc) => TestBench(
            child: ActionBlocBuilder(
              bloc: bloc,
              builder: (BuildContext context) => ContentBeacon(),
            ),
          ));
    });
  });
}
