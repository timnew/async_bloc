import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

void main() {
  group("ActionResult", () {
    group(".completed", () {
      final result = ActionResult.completed();

      test('should be a CompletedResult', () {
        expect(result, isInstanceOf<DoneState>());
      });
      test('gives the same instance', () {
        expect(ActionResult.completed(), same(result));
      });

      test("should have correct states", () {
        expect(result.isIdle, isFalse);
        expect(result.isWaiting, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isTrue);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
      });
    });

    group(".failed", () {
      final error = Exception("test error");
      final stackTrace = StackTrace.empty;

      final result = ActionResult.failed(error, stackTrace);

      test('should be a FailedResult', () {
        expect(result, isInstanceOf<ErrorState>());
      });

      test('should contain error and stack trace', () {
        final failed = result as ErrorState;

        expect(failed.error, same(error));
        expect(failed.stackTrace, same(stackTrace));
      });

      test('can create result without stacktrace', () {
        final failed = ActionResult.failed(error) as ErrorState;

        expect(failed.error, same(error));
        expect(failed.stackTrace, isNull);
      });

      test("should have correct states", () {
        expect(result.isIdle, isFalse);
        expect(result.isWaiting, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isTrue);
        expect(result.hasValue, isFalse);
      });
    });
  });
}
