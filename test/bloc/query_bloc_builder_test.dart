import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result_bloc.dart';
import 'package:test_beacon/test_beacon.dart';

typedef Widget BuildWidget(QueryCubit<String> bloc);

void main() {
  group("QueryBlocBuilder", () {
    final error = "error";
    final value = "value";
    final childBeacon = Beacon<String>();

    Widget buildWidget(QueryCubit<String> bloc) =>
        QueryBlocBuilder<QueryCubit<String>, String>(
          bloc: bloc,
          child: childBeacon,
          idleBuilder: (_, child) => Beacon<IdleState>(child: child),
          presetBuilder: (_, value, child) =>
              Beacon<IdleValueState>(value: value, child: child),
          workingBuilder: (_, child) => Beacon<WorkingState>(child: child),
          failedBuilder: (_, error, child) =>
              ErrorBeacon(error: error, child: child),
          succeededBuilder: (BuildContext context, value, child) =>
              ContentBeacon(content: value, child: child),
        );

    group("building AsyncQueryResult", () {
      testWidgets(".idle", (WidgetTester tester) async {
        final cubit = QueryCubit<String>(AsyncQueryResult<String>.idle());

        await tester.pumpWidgetOnScaffold(buildWidget(cubit));

        find.beacon<IdleState>().shouldFindOne();
        find.beacon<IdleValueState>().shouldFindNothing();
        find.beacon<WorkingState>().shouldFindNothing();
        find.errorBeacon().shouldFindNothing();
        find.contentBeacon().shouldFindNothing();
        find.beacon<String>().shouldFindOne();
      });

      testWidgets(".preset", (WidgetTester tester) async {
        final cubit =
            QueryCubit<String>(AsyncQueryResult<String>.preset(value));

        await tester.pumpWidgetOnScaffold(buildWidget(cubit));

        find.beacon<IdleState>().shouldFindNothing();
        find.beacon<IdleValueState>(value: value).shouldFindOne();
        find.beacon<WorkingState>().shouldFindNothing();
        find.errorBeacon().shouldFindNothing();
        find.contentBeacon().shouldFindNothing();
        find.beacon<String>().shouldFindOne();
      });

      testWidgets(".working", (WidgetTester tester) async {
        final cubit = QueryCubit<String>(AsyncQueryResult<String>.working());

        await tester.pumpWidgetOnScaffold(buildWidget(cubit));

        find.beacon<IdleState>().shouldFindNothing();
        find.beacon<IdleValueState>().shouldFindNothing();
        find.beacon<WorkingState>().shouldFindOne();
        find.errorBeacon().shouldFindNothing();
        find.contentBeacon().shouldFindNothing();
        find.beacon<String>().shouldFindOne();
      });

      testWidgets(".failed", (WidgetTester tester) async {
        final cubit =
            QueryCubit<String>(AsyncQueryResult<String>.failed(error));

        await tester.pumpWidgetOnScaffold(buildWidget(cubit));

        find.beacon<IdleState>().shouldFindNothing();
        find.beacon<IdleValueState>().shouldFindNothing();
        find.beacon<WorkingState>().shouldFindNothing();
        find.errorBeacon(error).shouldFindOne();
        find.contentBeacon().shouldFindNothing();
        find.beacon<String>().shouldFindOne();
      });

      testWidgets(".completed", (WidgetTester tester) async {
        final cubit =
            QueryCubit<String>(AsyncQueryResult<String>.succeeded(value));

        await tester.pumpWidgetOnScaffold(buildWidget(cubit));

        find.beacon<IdleState>().shouldFindNothing();
        find.beacon<IdleValueState>().shouldFindNothing();
        find.beacon<WorkingState>().shouldFindNothing();
        find.errorBeacon().shouldFindNothing();
        find.contentBeacon(value).shouldFindOne();
        find.beacon<String>().shouldFindOne();
      });
    });

    group("fallback builder", () {
      testWidgets(
          "presetBuilder should fallback to completedBuilder if not given",
          (WidgetTester tester) async {
        await tester.pumpWidgetOnScaffold(
          QueryBlocBuilder<QueryCubit<String>, String>(
            bloc: QueryCubit<String>(AsyncQueryResult.preset(value)),
            child: childBeacon,
            idleBuilder: (_, child) => Beacon<IdleState>(child: child),
            presetBuilder: null,
            workingBuilder: (_, child) => Beacon<WorkingState>(child: child),
            failedBuilder: (_, error, child) =>
                ErrorBeacon(error: error, child: child),
            succeededBuilder: (BuildContext context, value, child) =>
                ContentBeacon(content: value, child: child),
          ),
        );

        find.beacon<IdleState>().shouldFindNothing();
        find.beacon<IdleValueState>().shouldFindNothing();
        find.beacon<WorkingState>().shouldFindNothing();
        find.errorBeacon().shouldFindNothing();
        find.contentBeacon(value).shouldFindOne();
        find.beacon<String>().shouldFindOne();
      });

      testWidgets("idle builder should fallback to workingBuilder if not given",
          (WidgetTester tester) async {
        await tester.pumpWidgetOnScaffold(
          QueryBlocBuilder<QueryCubit<String>, String>(
            bloc: QueryCubit<String>(AsyncQueryResult.idle()),
            child: childBeacon,
            idleBuilder: null,
            presetBuilder: (_, value, child) =>
                Beacon<IdleValueState>(value: value, child: child),
            workingBuilder: (_, child) => Beacon<WorkingState>(child: child),
            failedBuilder: (_, error, child) =>
                ErrorBeacon(error: error, child: child),
            succeededBuilder: (BuildContext context, value, child) =>
                ContentBeacon(content: value, child: child),
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
        final cubit = QueryCubit<String>();

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

        completer.complete(value);
        await tester.pump(Duration.zero);
        await expectLater(capturedResult, completes);

        find.beacon<IdleState>().shouldFindNothing();
        find.beacon<WorkingState>().shouldFindNothing();
        find.errorBeacon().shouldFindNothing();
        find.contentBeacon(value).shouldFindOne();
        find.beacon<String>().shouldFindOne();
      });

      testWidgets("can capture future with error", (WidgetTester tester) async {
        final cubit = QueryCubit<String>();

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

        completer.completeError(error);
        await tester.pump(Duration.zero);
        await expectLater(capturedResult, completes);

        find.beacon<IdleState>().shouldFindNothing();
        find.beacon<WorkingState>().shouldFindNothing();
        find.errorBeacon(error).shouldFindOne();
        find.contentBeacon(value).shouldFindNothing();
        find.beacon<String>().shouldFindOne();
      });
    });
  });
}
