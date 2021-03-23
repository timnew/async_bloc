import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';
import 'package:stated_result/stated_result_builder.dart';

import '../widget_test/widget_tester.dart';

typedef Future buildResult<T>(WidgetTester tester, T result);

void main() {
  group("QueryResultBuilder", () {
    final value = "value";

    void runTestSet({
      required buildResult<AsyncQueryResult<String>> buildAsyncResult,
      required buildResult<QueryResult<String>> buildSyncResult,
    }) {
      testWidgets("it should build AsyncResultAction.pending()",
          (WidgetTester tester) async {
        await buildAsyncResult(tester, AsyncQueryResult.pending());

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("it should build AsyncResultAction.wating()",
          (WidgetTester tester) async {
        await buildAsyncResult(tester, AsyncQueryResult.waiting());

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("it should build AsyncResultAction.completed()",
          (WidgetTester tester) async {
        await buildAsyncResult(tester, AsyncQueryResult.failed("error"));

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon("error").shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("it should build AsyncResultAction.failed()",
          (WidgetTester tester) async {
        await buildAsyncResult(tester, AsyncQueryResult.succeeded(value));

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindOne();
      });

      testWidgets("it should build ResultAction.completed()",
          (WidgetTester tester) async {
        await buildSyncResult(tester, QueryResult.succeeded(value));

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindOne();
      });

      testWidgets("it should build ResultAction.failed()",
          (WidgetTester tester) async {
        await buildSyncResult(tester, QueryResult.failed("error"));

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });
    }

    group("with explicit builders", () {
      Future _buildAsyncResult(
          WidgetTester tester, AsyncQueryResult<String> result) async {
        await tester.pumpWidget(
          TestBench(
            child: QueryResultBuilder<String>(
              pendingBuilder: (_) => PendingBeacon(),
              waitingBuilder: (_) => WaitingBeacon(),
              failedBuilder: (_, errorInfo) => ErrorBeacon(errorInfo.error),
              builder: (_, value) => ContentBeacon(value),
              result: result,
            ),
          ),
        );
      }

      Future _buildSyncResult(
          WidgetTester tester, QueryResult<String> result) async {
        await tester.pumpWidget(
          TestBench(
            child: QueryResultBuilder<String>.sync(
              failedBuilder: (_, errorInfo) => ErrorBeacon(errorInfo.error),
              builder: (_, value) => ContentBeacon(value),
              result: result,
            ),
          ),
        );
      }

      runTestSet(
        buildAsyncResult: _buildAsyncResult,
        buildSyncResult: _buildSyncResult,
      );
    });

    group("with default buidlers", () {
      Future _buildAsyncResult(
          WidgetTester tester, AsyncQueryResult<String> result) async {
        await tester.pumpWidget(
          TestBench(
            child: DefaultResultBuilder(
              pendingBuilder: (_) => PendingBeacon(),
              waitingBuilder: (_) => WaitingBeacon(),
              failedBuilder: (_, errorInfo) => ErrorBeacon(errorInfo.error),
              child: QueryResultBuilder<String>(
                builder: (_, value) => ContentBeacon(value),
                result: result,
              ),
            ),
          ),
        );
      }

      Future _buildSyncResult(
          WidgetTester tester, QueryResult<String> result) async {
        await tester.pumpWidget(
          TestBench(
            child: DefaultResultBuilder(
              pendingBuilder: (_) => PendingBeacon(),
              waitingBuilder: (_) => WaitingBeacon(),
              failedBuilder: (_, errorInfo) => ErrorBeacon(errorInfo.error),
              child: QueryResultBuilder<String>.sync(
                builder: (_, value) => ContentBeacon(value),
                result: result,
              ),
            ),
          ),
        );
      }

      runTestSet(
        buildAsyncResult: _buildAsyncResult,
        buildSyncResult: _buildSyncResult,
      );
    });

    group("with global default builders", () {
      Future _buildAsyncResult(
          WidgetTester tester, AsyncQueryResult<String> result) async {
        await tester.pumpWidget(
          TestBench(
            child: QueryResultBuilder<String>(
              builder: (_, value) => ContentBeacon(value),
              result: result,
            ),
          ),
        );
      }

      Future _buildSyncResult(
          WidgetTester tester, QueryResult<String> result) async {
        await tester.pumpWidget(
          TestBench(
            child: QueryResultBuilder<String>.sync(
              builder: (_, value) => ContentBeacon(value),
              result: result,
            ),
          ),
        );
      }

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

      runTestSet(
        buildAsyncResult: _buildAsyncResult,
        buildSyncResult: _buildSyncResult,
      );
    });
  });
}
