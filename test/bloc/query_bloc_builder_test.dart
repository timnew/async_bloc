import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';
import 'package:stated_result/stated_result_bloc.dart';
import 'package:stated_result/stated_result_builder.dart';

import '../widget_tester/custom_matchers.dart';
import '../widget_tester/widget_tester.dart';

typedef Widget BuildWidget(QueryCubit<String> bloc);

void main() {
  group("QueryBlocBuilder", () {
    final error = "error";
    final value = "value";

    void runTestSet(BuildWidget buildWidget) {
      group("building AsyncQueryResult", () {
        testWidgets(".pending", (WidgetTester tester) async {
          final cubit = QueryCubit<String>(AsyncQueryResult<String>.pending());

          await tester.pumpWidget(buildWidget(cubit));

          findPendingBeacon.shouldFindOne();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".waiting", (WidgetTester tester) async {
          final cubit = QueryCubit<String>(AsyncQueryResult<String>.waiting());

          await tester.pumpWidget(buildWidget(cubit));

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindOne();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".failed", (WidgetTester tester) async {
          final cubit =
              QueryCubit<String>(AsyncQueryResult<String>.failed(error));

          await tester.pumpWidget(buildWidget(cubit));

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon(error).shouldFindOne();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".succeeded", (WidgetTester tester) async {
          final cubit =
              QueryCubit<String>(AsyncQueryResult<String>.succeeded(value));

          await tester.pumpWidget(buildWidget(cubit));

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon(value).shouldFindOne();
        });
      });

      testWidgets("can be updated with succeeded", (WidgetTester tester) async {
        final cubit = QueryCubit<String>();

        await tester.pumpWidget(buildWidget(cubit));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer<QueryResult<String>>();

        // ignore: unawaited_futures
        cubit.updateWith(completer.future);
        await tester.pump();

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        completer.complete(QueryResult<String>.succeeded(value));
        await tester.pump(Duration.zero);

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon(value).shouldFindOne();
      });

      testWidgets("can be updated with failed", (WidgetTester tester) async {
        final cubit = QueryCubit<String>();

        await tester.pumpWidget(buildWidget(cubit));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer<QueryResult<String>>();

        // ignore: unawaited_futures
        cubit.updateWith(completer.future);
        await tester.pump();

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        completer.complete(QueryResult<String>.failed(error));
        await tester.pump(Duration.zero);

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon(error).shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("can capture future", (WidgetTester tester) async {
        final cubit = QueryCubit<String>();

        await tester.pumpWidget(buildWidget(cubit));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer<String>();

        final capturedResult = cubit.captureResult(completer.future);
        await tester.pump();

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        completer.complete(value);
        await tester.pump(Duration.zero);
        await expectLater(
          capturedResult,
          completion(AsyncQueryResult.succeeded(value)),
        );

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon(value).shouldFindOne();
      });

      testWidgets("can capture future with error", (WidgetTester tester) async {
        final cubit = QueryCubit<String>();

        await tester.pumpWidget(buildWidget(cubit));

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        final completer = Completer<String>();

        final capturedResult = cubit.captureResult(completer.future);
        await tester.pump();

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();

        completer.completeError(error);
        await tester.pump(Duration.zero);
        await expectLater(
          capturedResult,
          completion(HasError(equals(error))),
        );

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon(error).shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });
    }

    group("explicit builders", () {
      runTestSet((QueryCubit<String> bloc) => TestBench(
            child: QueryBlocBuilder<QueryCubit<String>, String>(
              bloc: bloc,
              pendingBuilder: (_) => PendingBeacon(),
              waitingBuilder: (_) => WaitingBeacon(),
              failedBuilder: (_, result) => ErrorBeacon(result.error),
              builder: (_, value) => ContentBeacon(value),
            ),
          ));
    });

    group("default builders", () {
      runTestSet((QueryCubit<String> bloc) => TestBench(
            child: DefaultResultBuilder(
              pendingBuilder: (_) => PendingBeacon(),
              waitingBuilder: (_) => WaitingBeacon(),
              failedBuilder: (_, result) => ErrorBeacon(result.error),
              child: QueryBlocBuilder<QueryCubit<String>, String>(
                bloc: bloc,
                builder: (_, value) => ContentBeacon(value),
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

      runTestSet((QueryCubit<String> bloc) => TestBench(
            child: QueryBlocBuilder<QueryCubit<String>, String>(
              bloc: bloc,
              builder: (_, value) => ContentBeacon(value),
            ),
          ));
    });
  });
}
