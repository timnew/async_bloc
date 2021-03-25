import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';
import 'package:stated_result/stated_result_builder.dart';

import '../widget_tester/widget_tester.dart';

typedef Future buildResult<T>(WidgetTester tester, T result);

void main() {
  group("ActionResultBuilder", () {
    void runTestSet({
      required buildResult<AsyncActionResult> buildAsyncResult,
      required buildResult<ActionResult> buildSyncResult,
    }) {
      group("it should build AsyncResultAction", () {
        testWidgets(".pending()", (WidgetTester tester) async {
          await buildAsyncResult(tester, AsyncActionResult.pending());

          findPendingBeacon.shouldFindOne();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".wating()", (WidgetTester tester) async {
          await buildAsyncResult(tester, AsyncActionResult.waiting());

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindOne();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".completed()", (WidgetTester tester) async {
          await buildAsyncResult(tester, AsyncActionResult.failed("error"));

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon("error").shouldFindOne();
          findContentBeacon().shouldFindNothing();
        });

        testWidgets(".failed()", (WidgetTester tester) async {
          await buildAsyncResult(tester, AsyncActionResult.completed());

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindOne();
        });
      });

      group("it should build ResultAction", () {
        testWidgets(".completed()", (WidgetTester tester) async {
          await buildSyncResult(tester, ActionResult.completed());

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon().shouldFindNothing();
          findContentBeacon().shouldFindOne();
        });

        testWidgets(".failed()", (WidgetTester tester) async {
          await buildSyncResult(tester, ActionResult.failed("error"));

          findPendingBeacon.shouldFindNothing();
          findWaitingBeacon.shouldFindNothing();
          findErrorBeacon().shouldFindOne();
          findContentBeacon().shouldFindNothing();
        });
      });
    }

    group("with explicit builders", () {
      Future _buildAsyncResult(
          WidgetTester tester, AsyncActionResult result) async {
        await tester.pumpWidget(
          TestBench(
            child: ActionResultBuilder(
              pendingBuilder: (_) => PendingBeacon(),
              waitingBuilder: (_) => WaitingBeacon(),
              failedBuilder: (_, errorInfo) => ErrorBeacon(errorInfo.error),
              builder: (_) => ContentBeacon(),
              result: result,
            ),
          ),
        );
      }

      Future _buildSyncResult(WidgetTester tester, ActionResult result) async {
        await tester.pumpWidget(
          TestBench(
            child: ActionResultBuilder.sync(
              failedBuilder: (_, errorInfo) => ErrorBeacon(errorInfo.error),
              builder: (_) => ContentBeacon(),
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
          WidgetTester tester, AsyncActionResult result) async {
        await tester.pumpWidget(
          TestBench(
            child: DefaultResultBuilder(
              pendingBuilder: (_) => PendingBeacon(),
              waitingBuilder: (_) => WaitingBeacon(),
              failedBuilder: (_, errorInfo) => ErrorBeacon(errorInfo.error),
              child: ActionResultBuilder(
                builder: (_) => ContentBeacon(),
                result: result,
              ),
            ),
          ),
        );
      }

      Future _buildSyncResult(WidgetTester tester, ActionResult result) async {
        await tester.pumpWidget(
          TestBench(
            child: DefaultResultBuilder(
              pendingBuilder: (_) => PendingBeacon(),
              waitingBuilder: (_) => WaitingBeacon(),
              failedBuilder: (_, errorInfo) => ErrorBeacon(errorInfo.error),
              child: ActionResultBuilder.sync(
                builder: (_) => ContentBeacon(),
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
          WidgetTester tester, AsyncActionResult result) async {
        await tester.pumpWidget(
          TestBench(
            child: ActionResultBuilder(
              builder: (_) => ContentBeacon(),
              result: result,
            ),
          ),
        );
      }

      Future _buildSyncResult(WidgetTester tester, ActionResult result) async {
        await tester.pumpWidget(
          TestBench(
            child: ActionResultBuilder.sync(
              builder: (_) => ContentBeacon(),
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
