import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

void main() {
  group("AsyncActionResult", () {
    group("default constructor", () {
      final result = AsyncActionResult();

      test('should be a PendingResult', () {
        expect(result, isInstanceOf<PendingResult>());
      });

      test('gives the same instance', () {
        expect(AsyncActionResult(), same(result));
      });
    });

    group(".busy", () {
      final result = AsyncActionResult.busy();

      test('should be a BusyResult', () {
        expect(result, isInstanceOf<BusyResult>());
      });

      test('gives the same instance', () {
        expect(AsyncActionResult.busy(), same(result));
      });
    });

    group(".completed", () {
      final result = AsyncActionResult.completed();

      test('should be a CompletedResult', () {
        expect(result, isInstanceOf<CompletedResult>());
      });

      test('gives the same instance', () {
        expect(AsyncActionResult.completed(), same(result));
      });
    });

    group(".failed", () {
      final error = Exception("test error");
      final stackTrace = StackTrace.empty;

      final result = AsyncActionResult.failed(error, stackTrace);

      test('should be a FailedResult', () {
        expect(result, isInstanceOf<FailedResult>());
      });

      test('should contain error and stack trace', () {
        final failed = result as FailedResult;

        expect(failed.error, same(error));
        expect(failed.stackTrace, same(stackTrace));
      });

      test('can create result without stacktrace', () {
        final failed = AsyncActionResult.failed(error) as FailedResult;

        expect(failed.error, same(error));
        expect(failed.stackTrace, isNull);
      });
    });
  });
}
