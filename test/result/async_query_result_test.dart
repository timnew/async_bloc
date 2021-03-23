import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

void main() {
  group("AsyncQueryResult", () {
    final value = "value";
    group("default constructor", () {
      final result = AsyncQueryResult<String>();

      test('should be a PendingResult', () {
        expect(result, isInstanceOf<PendingResult>());
      });

      test('gives the same instance', () {
        expect(AsyncQueryResult(), same(result));
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isTrue);
        expect(result.isWaiting, isFalse);
        expect(result.isFinished, isFalse);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
      });
    });

    group(".initialValue", () {
      final result = AsyncQueryResult.initialValue(value);

      test('should be a CompletedResult', () {
        expect(result, isInstanceOf<InitialValueResult<String>>());
      });

      test("should has value", () {
        final succeeded = result as InitialValueResult<String>;
        expect(value, succeeded.value);
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isTrue);
        expect(result.isWaiting, isFalse);
        expect(result.isFinished, isFalse);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isTrue);
      });
    });

    group(".waiting", () {
      final result = AsyncQueryResult.waiting();

      test('should be a WaitingResult', () {
        expect(result, isInstanceOf<WaitingResult>());
      });

      test('gives the same instance', () {
        expect(AsyncQueryResult.waiting(), same(result));
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isFalse);
        expect(result.isWaiting, isTrue);
        expect(result.isFinished, isFalse);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
      });
    });

    group(".succeeded", () {
      final result = AsyncQueryResult.succeeded(value);

      test('should be a CompletedResult', () {
        expect(result, isInstanceOf<SucceededResult<String>>());
      });

      test("should has value", () {
        final succeeded = result as SucceededResult<String>;
        expect(value, succeeded.value);
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isFalse);
        expect(result.isWaiting, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isTrue);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isTrue);
      });
    });

    group(".failed", () {
      final error = Exception("test error");
      final stackTrace = StackTrace.empty;

      final result = AsyncQueryResult.failed(error, stackTrace);

      test('should be a FailedResult', () {
        expect(result, isInstanceOf<FailedResult>());
      });

      test('should contain error and stack trace', () {
        final failed = result as FailedResult;

        expect(failed.error, same(error));
        expect(failed.stackTrace, same(stackTrace));
      });

      test('can create result without stacktrace', () {
        final failed = AsyncQueryResult.failed(error) as FailedResult;

        expect(failed.error, same(error));
        expect(failed.stackTrace, isNull);
      });

      test("should have correct states", () {
        expect(result.isNotStarted, isFalse);
        expect(result.isWaiting, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isTrue);
        expect(result.hasValue, isFalse);
      });
    });

    group(".mapValue", () {
      test("should map pending", () {
        final result = AsyncQueryResult<int>.pending();

        expect(
          result.mapValue((value) => value.toString()),
          AsyncQueryResult<String>.pending(),
        );
      });

      test("should map initialValue", () {
        final result = AsyncQueryResult<int>.initialValue(100);
        expect(
          result.mapValue((value) => value.toString()),
          AsyncQueryResult<String>.initialValue("100"),
        );
      });

      test("should map waiting", () {
        final result = AsyncQueryResult<int>.waiting();

        expect(
          result.mapValue((value) => value.toString()),
          AsyncQueryResult<String>.waiting(),
        );
      });
      test("should map success", () {
        final result = AsyncQueryResult<int>.succeeded(100);
        expect(
          result.mapValue((value) => value.toString()),
          AsyncQueryResult.succeeded("100"),
        );
      });

      test("should map failed", () {
        final error = "error";
        final result = AsyncQueryResult<int>.failed(error);

        expect(
          result.mapValue((value) => value.toString()),
          AsyncQueryResult<String>.failed(error),
        );
      });
    });
  });
}
