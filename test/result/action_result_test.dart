import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

void main() {
  group("ActionResult", () {
    group(".completed", () {
      final result = ActionResult.completed();

      test('should be a CompletedResult', () {
        expect(result, isInstanceOf<CompletedResult>());
      });
      test('gives the same instance', () {
        expect(ActionResult.completed(), same(result));
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isFalse);
        expect(result.isBusy, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isTrue);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
        expect(() => result.ensureNoParallelRun(), returnsNormally);
      });
    });

    group(".failed", () {
      final error = Exception("test error");
      final stackTrace = StackTrace.empty;

      final result = ActionResult.failed(error, stackTrace);

      test('should be a FailedResult', () {
        expect(result, isInstanceOf<FailedResult>());
      });

      test('should contain error and stack trace', () {
        final failed = result as FailedResult;

        expect(failed.error, same(error));
        expect(failed.stackTrace, same(stackTrace));
      });

      test('can create result without stacktrace', () {
        final failed = ActionResult.failed(error) as FailedResult;

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
        expect(() => result.ensureNoParallelRun(), returnsNormally);
      });
    });
  });
}
