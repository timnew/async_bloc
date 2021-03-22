import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';
import 'package:stated_result/stated_result_builder.dart';

import '../widget_test/widget_tester.dart';

void main() {
  group("ActionResultBuilder", () {
    group("with explicit builders", () {
      Future _buildAsyncResult(
          WidgetTester tester, AsyncActionResult result) async {
        await tester.pumpWidget(
          TestBench(
            child: ActionResultBuilder(
              pendingBuilder: (_) => PendingBeacon(),
              waitingBuilder: (_) => WaitingBeacon(),
              failedBuilder: (_, errorInfo) => ErrorBeacon(errorInfo.error),
              completedBuilder: (_) => ContentBeacon(),
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
              completedBuilder: (_) => ContentBeacon(),
              result: result,
            ),
          ),
        );
      }

      testWidgets("it should build AsyncResultAction.pending()",
          (WidgetTester tester) async {
        await _buildAsyncResult(tester, AsyncActionResult.pending());

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("it should build AsyncResultAction.wating()",
          (WidgetTester tester) async {
        await _buildAsyncResult(tester, AsyncActionResult.waiting());

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("it should build AsyncResultAction.completed()",
          (WidgetTester tester) async {
        await _buildAsyncResult(tester, AsyncActionResult.failed("error"));

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon("error").shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("it should build AsyncResultAction.failed()",
          (WidgetTester tester) async {
        await _buildAsyncResult(tester, AsyncActionResult.completed());

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindOne();
      });

      testWidgets("it should build ResultAction.completed()",
          (WidgetTester tester) async {
        await _buildSyncResult(tester, ActionResult.completed());

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindOne();
      });

      testWidgets("it should build ResultAction.failed()",
          (WidgetTester tester) async {
        await _buildSyncResult(tester, ActionResult.failed("error"));

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });
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
                completedBuilder: (_) => ContentBeacon(),
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
                completedBuilder: (_) => ContentBeacon(),
                result: result,
              ),
            ),
          ),
        );
      }

      testWidgets("it should build AsyncResultAction.pending()",
          (WidgetTester tester) async {
        await _buildAsyncResult(tester, AsyncActionResult.pending());

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("it should build AsyncResultAction.wating()",
          (WidgetTester tester) async {
        await _buildAsyncResult(tester, AsyncActionResult.waiting());

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("it should build AsyncResultAction.completed()",
          (WidgetTester tester) async {
        await _buildAsyncResult(tester, AsyncActionResult.failed("error"));

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon("error").shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("it should build AsyncResultAction.failed()",
          (WidgetTester tester) async {
        await _buildAsyncResult(tester, AsyncActionResult.completed());

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindOne();
      });

      testWidgets("it should build ResultAction.completed()",
          (WidgetTester tester) async {
        await _buildSyncResult(tester, ActionResult.completed());

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindOne();
      });

      testWidgets("it should build ResultAction.failed()",
          (WidgetTester tester) async {
        await _buildSyncResult(tester, ActionResult.failed("error"));

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon("error").shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });
    });

    group("with global default builders", () {
      Future _buildAsyncResult(
          WidgetTester tester, AsyncActionResult result) async {
        await tester.pumpWidget(
          TestBench(
            child: ActionResultBuilder(
              completedBuilder: (_) => ContentBeacon(),
              result: result,
            ),
          ),
        );
      }

      Future _buildSyncResult(WidgetTester tester, ActionResult result) async {
        await tester.pumpWidget(
          TestBench(
            child: ActionResultBuilder.sync(
              completedBuilder: (_) => ContentBeacon(),
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

      testWidgets("it should build AsyncResultAction.pending()",
          (WidgetTester tester) async {
        await _buildAsyncResult(tester, AsyncActionResult.pending());

        findPendingBeacon.shouldFindOne();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("it should build AsyncResultAction.wating()",
          (WidgetTester tester) async {
        await _buildAsyncResult(tester, AsyncActionResult.waiting());

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindOne();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("it should build AsyncResultAction.completed()",
          (WidgetTester tester) async {
        await _buildAsyncResult(tester, AsyncActionResult.failed("error"));

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon("error").shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });

      testWidgets("it should build AsyncResultAction.failed()",
          (WidgetTester tester) async {
        await _buildAsyncResult(tester, AsyncActionResult.completed());

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindOne();
      });

      testWidgets("it should build ResultAction.completed()",
          (WidgetTester tester) async {
        await _buildSyncResult(tester, ActionResult.completed());

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon().shouldFindNothing();
        findContentBeacon().shouldFindOne();
      });

      testWidgets("it should build ResultAction.failed()",
          (WidgetTester tester) async {
        await _buildSyncResult(tester, ActionResult.failed("error"));

        findPendingBeacon.shouldFindNothing();
        findWaitingBeacon.shouldFindNothing();
        findErrorBeacon("error").shouldFindOne();
        findContentBeacon().shouldFindNothing();
      });
    });
  });
}
