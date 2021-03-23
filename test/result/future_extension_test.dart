import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

void main() {
  group("StatedResultFutureExtension", () {
    final value = "value";
    final error = "error";

    group(".asActionResult()", () {
      group("Future<void>", () {
        test("runs", () async {
          Future<void> runs() async {}

          final result = await runs().asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<CompletedResult>());
        });

        test("yields error", () async {
          Future<void> fails() async {
            throw error;
          }

          final result = await fails().asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<FailedResult>());
          expect(result.asFailed().error, error);
        });
      });

      group("Future<String>", () {
        test("yields value", () async {
          final result = await Future.value(value).asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<CompletedResult>());
        });

        test("yields error", () async {
          final result = await Future.error(error).asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<FailedResult>());
          expect(result.asFailed().error, error);
        });
      });

      group("Future<ActionResult>", () {
        test("yields completed", () async {
          final result =
              await Future.value(ActionResult.completed()).asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<CompletedResult>());
        });

        test("yields failed", () async {
          final result =
              await Future.value(ActionResult.failed(error)).asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<FailedResult>());
        });

        test("yields error", () async {
          final result = await Future.error(error).asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<FailedResult>());
          expect(result.asFailed().error, error);
        });
      });

      group("Future<AsyncActionResult>", () {
        test("yields pending", () async {
          expect(
            () async => await Future.value(AsyncActionResult.pending())
                .asActionResult(),
            throwsUnsupportedError,
          );
        });

        test("yields waiting", () async {
          expect(
            () async => await Future.value(AsyncActionResult.waiting())
                .asActionResult(),
            throwsUnsupportedError,
          );
        });

        test("yields completed", () async {
          final result = await Future.value(AsyncActionResult.completed())
              .asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<CompletedResult>());
        });

        test("yields failed", () async {
          final result = await Future.value(AsyncActionResult.failed(error))
              .asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<FailedResult>());
        });

        test("yields error", () async {
          final result = await Future.error(error).asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<FailedResult>());
          expect(result.asFailed().error, error);
        });
      });

      group("Future<QueryResult<String>>", () {
        test("yields completed", () async {
          final result =
              await Future.value(QueryResult.succeeded(value)).asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<CompletedResult>());
        });

        test("yields failed", () async {
          final result =
              await Future.value(QueryResult.failed(error)).asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<FailedResult>());
        });

        test("yields error", () async {
          final result = await Future.error(error).asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<FailedResult>());
          expect(result.asFailed().error, error);
        });
      });

      group("Future<AsyncQueryResult<String>>", () {
        test("yields pending", () async {
          expect(
            () async =>
                await Future.value(AsyncQueryResult.pending()).asActionResult(),
            throwsUnsupportedError,
          );
        });

        test("yields initialValue", () async {
          expect(
            () async => await Future.value(AsyncQueryResult.initialValue(value))
                .asActionResult(),
            throwsUnsupportedError,
          );
        });

        test("yields waiting", () async {
          expect(
            () async =>
                await Future.value(AsyncQueryResult.waiting()).asActionResult(),
            throwsUnsupportedError,
          );
        });

        test("yields succeeded", () async {
          final result = await Future.value(AsyncQueryResult.succeeded(value))
              .asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<CompletedResult>());
        });

        test("yields failed", () async {
          final result = await Future.value(AsyncQueryResult.failed(error))
              .asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<FailedResult>());
        });

        test("yields error", () async {
          final result = await Future.error(error).asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<FailedResult>());
          expect(result.asFailed().error, error);
        });
      });
    });

    group(".asQueryResult()", () {
      group("Future<String>", () {
        test("yields value", () async {
          final result = await Future.value(value).asQueryResult();
          expect(result, QueryResult.succeeded(value));
        });

        test("yields error", () async {
          final result = await Future<String>.error(error).asQueryResult();
          expect(result, isInstanceOf<QueryResult<String>>());
          expect(result, isInstanceOf<FailedResult>());
          expect(result.asFailed().error, error);
        });
      });
    });
  });
}
