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

      test("should have correct states", () {
        expect(result.isNotStarted, isTrue);
        expect(result.isBusy, isFalse);
        expect(result.isFinished, isFalse);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
        expect(() => result.ensureNotBusy(), returnsNormally);
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

      test("should have correct states", () {
        expect(result.isNotStarted, isFalse);
        expect(result.isBusy, isTrue);
        expect(result.isFinished, isFalse);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
        expect(() => result.ensureNotBusy(), throwsStateError);
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

      test("should have correct states", () {
        expect(result.isNotStarted, isFalse);
        expect(result.isBusy, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isTrue);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
        expect(() => result.ensureNotBusy(), returnsNormally);
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

      test("should have correct states", () {
        expect(result.isNotStarted, isFalse);
        expect(result.isBusy, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isTrue);
        expect(result.hasValue, isFalse);
        expect(() => result.ensureNotBusy(), returnsNormally);
      });
    });
  });
}
