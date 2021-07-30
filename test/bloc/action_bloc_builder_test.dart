import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result_bloc.dart';
import 'package:test_beacon/test_beacon.dart';

void main() {
  group("ActionBlocBuilder", () {
    final error = "error";
    final childBeacon = Beacon<String>();

    group("explicit builders", () {
      Widget buildWidget(ActionCubit bloc) => ActionBlocBuilder(
            bloc: bloc,
            child: childBeacon,
            idleBuilder: (_, child) => Beacon<IdleState>(child: child),
            workingBuilder: (_, child) => Beacon<WorkingState>(child: child),
            failedBuilder: (_, error, child) =>
                ErrorBeacon(error: error, child: child),
            succeededBuilder: (BuildContext context, child) =>
                ContentBeacon(child: child),
          );

      group("building AsyncActionResult", () {
        testWidgets(".idle", (WidgetTester tester) async {
          final cubit = ActionCubit(AsyncActionResult.idle());

          await tester.pumpWidgetOnScaffold(buildWidget(cubit));

          find.beacon<IdleState>().shouldFindOne();
          find.beacon<WorkingState>().shouldFindNothing();
          find.errorBeacon().shouldFindNothing();
          find.contentBeacon().shouldFindNothing();
          find.beacon<String>().shouldFindOne();
        });

        testWidgets(".working", (WidgetTester tester) async {
          final cubit = ActionCubit(AsyncActionResult.working());

          await tester.pumpWidgetOnScaffold(buildWidget(cubit));

          find.beacon<IdleState>().shouldFindNothing();
          find.beacon<WorkingState>().shouldFindOne();
          find.errorBeacon().shouldFindNothing();
          find.contentBeacon().shouldFindNothing();
          find.beacon<String>().shouldFindOne();
        });

        testWidgets(".failed", (WidgetTester tester) async {
          final cubit = ActionCubit(AsyncActionResult.failed(error));

          await tester.pumpWidgetOnScaffold(buildWidget(cubit));

          find.beacon<IdleState>().shouldFindNothing();
          find.beacon<WorkingState>().shouldFindNothing();
          find.errorBeacon(error).shouldFindOne();
          find.contentBeacon().shouldFindNothing();
          find.beacon<String>().shouldFindOne();
        });

        testWidgets(".completed", (WidgetTester tester) async {
          final cubit = ActionCubit(AsyncActionResult.succeeded());

          await tester.pumpWidgetOnScaffold(buildWidget(cubit));

          find.beacon<IdleState>().shouldFindNothing();
          find.beacon<WorkingState>().shouldFindNothing();
          find.errorBeacon().shouldFindNothing();
          find.contentBeacon().shouldFindOne();
          find.beacon<String>().shouldFindOne();
        });
      });

      group("fallback builder", () {
        testWidgets(
            "idle builder should fallback to workingBuilder if not given",
            (WidgetTester tester) async {
          await tester.pumpWidgetOnScaffold(
            ActionBlocBuilder<ActionCubit>(
              bloc: ActionCubit(AsyncActionResult.idle()),
              child: childBeacon,
              idleBuilder: null,
              workingBuilder: (_, child) => Beacon<WorkingState>(child: child),
              failedBuilder: (_, error, child) =>
                  ErrorBeacon(error: error, child: child),
              succeededBuilder: (BuildContext context, child) =>
                  ContentBeacon(child: child),
            ),
          );

          find.beacon<IdleState>().shouldFindNothing();
          find.beacon<IdleValueState>().shouldFindNothing();
          find.beacon<WorkingState>().shouldFindOne();
          find.errorBeacon().shouldFindNothing();
          find.contentBeacon().shouldFindNothing();
          find.beacon<String>().shouldFindOne();
        });
      });
      group(".captureResult", () {
        testWidgets("can capture future", (WidgetTester tester) async {
          final cubit = ActionCubit();

          await tester.pumpWidgetOnScaffold(buildWidget(cubit));

          find.beacon<IdleState>().shouldFindOne();
          find.beacon<WorkingState>().shouldFindNothing();
          find.errorBeacon().shouldFindNothing();
          find.contentBeacon().shouldFindNothing();
          find.beacon<String>().shouldFindOne();

          final completer = Completer<String>();

          final capturedResult = cubit.captureResult(completer.future);
          await tester.pump();

          find.beacon<IdleState>().shouldFindNothing();
          find.beacon<WorkingState>().shouldFindOne();
          find.errorBeacon().shouldFindNothing();
          find.contentBeacon().shouldFindNothing();
          find.beacon<String>().shouldFindOne();

          final value = "value";
          completer.complete(value);
          await tester.pump(Duration.zero);
          await expectLater(capturedResult, completes);

          find.beacon<IdleState>().shouldFindNothing();
          find.beacon<WorkingState>().shouldFindNothing();
          find.errorBeacon().shouldFindNothing();
          find.contentBeacon().shouldFindOne();
          find.beacon<String>().shouldFindOne();
        });

        testWidgets("can capture future with error",
            (WidgetTester tester) async {
          final cubit = ActionCubit();

          await tester.pumpWidgetOnScaffold(buildWidget(cubit));

          find.beacon<IdleState>().shouldFindOne();
          find.beacon<WorkingState>().shouldFindNothing();
          find.errorBeacon().shouldFindNothing();
          find.contentBeacon().shouldFindNothing();
          find.beacon<String>().shouldFindOne();

          final completer = Completer();

          final capturedResult = cubit.captureResult(completer.future);
          await tester.pump();

          find.beacon<IdleState>().shouldFindNothing();
          find.beacon<WorkingState>().shouldFindOne();
          find.errorBeacon().shouldFindNothing();
          find.contentBeacon().shouldFindNothing();
          find.beacon<String>().shouldFindOne();

          completer.completeError(error);
          await tester.pump(Duration.zero);
          await expectLater(capturedResult, completes);

          find.beacon<IdleState>().shouldFindNothing();
          find.beacon<WorkingState>().shouldFindNothing();
          find.errorBeacon(error).shouldFindOne();
          find.contentBeacon().shouldFindNothing();
          find.beacon<String>().shouldFindOne();
        });
      });
    });
  });
}
