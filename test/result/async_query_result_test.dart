import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

void main() {
  group("AsyncQueryResult", () {
    final value = "value";
    final error = "error";
    group("default constructor", () {
      final result = AsyncQueryResult<String>();

      test('should be a PendingResult', () {
        expect(result, isInstanceOf<IdleState>());
      });

      test('should be a AsyncQueryResult', () {
        expect(result, isInstanceOf<AsyncQueryResult<String>>());
      });

      test('gives the same instance', () {
        expect(AsyncQueryResult(), same(result));
      });

      test("should have correct states", () {
        expect(result.isIdle, isTrue);
        expect(result.isWaiting, isFalse);
        expect(result.isFinished, isFalse);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
      });
    });

    group(".initialValue", () {
      final result = AsyncQueryResult<String>.initialValue(value);

      test('should be a CompletedResult', () {
        expect(result, isInstanceOf<IdleValueState<String>>());
      });
      test('should be a AsyncQueryResult', () {
        expect(result, isInstanceOf<AsyncQueryResult<String>>());
      });
      test("should has value", () {
        final succeeded = result as IdleValueState<String>;
        expect(value, succeeded.value);
      });

      test("should have correct states", () {
        expect(result.isIdle, isTrue);
        expect(result.isWaiting, isFalse);
        expect(result.isFinished, isFalse);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isTrue);
      });
    });

    group(".waiting", () {
      final result = AsyncQueryResult<String>.waiting();

      test('should be a WaitingResult', () {
        expect(result, isInstanceOf<WaitingState>());
      });

      test('should be a AsyncQueryResult', () {
        expect(result, isInstanceOf<AsyncQueryResult<String>>());
      });

      test('gives the same instance', () {
        expect(AsyncQueryResult.waiting(), same(result));
      });

      test("should have correct states", () {
        expect(result.isIdle, isFalse);
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
        expect(result, isInstanceOf<DoneValueState<String>>());
      });

      test('should be a AsyncQueryResult', () {
        expect(result, isInstanceOf<AsyncQueryResult<String>>());
      });

      test("should has value", () {
        final succeeded = result as DoneValueState<String>;
        expect(value, succeeded.value);
      });

      test("should have correct states", () {
        expect(result.isIdle, isFalse);
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

      final result = AsyncQueryResult<String>.failed(error, stackTrace);

      test('should be a FailedResult', () {
        expect(result, isInstanceOf<ErrorState>());
      });

      test('should be a AsyncQueryResult', () {
        expect(result, isInstanceOf<AsyncQueryResult<String>>());
      });

      test('should contain error and stack trace', () {
        final failed = result as ErrorState;

        expect(failed.error, same(error));
        expect(failed.stackTrace, same(stackTrace));
      });

      test('can create result without stacktrace', () {
        final failed = AsyncQueryResult.failed(error) as ErrorState;

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

    group(".fromValue", () {
      test("value is SucceededResult", () {
        final result = AsyncQueryResult.fromValue(value);
        expect(result, AsyncQueryResult.succeeded(value));
      });

      test("null is PendingResult", () {
        final result = AsyncQueryResult.fromValue(null);
        expect(result, AsyncQueryResult.pending());
      });
    });

    group(".updateWith", () {
      test("should update value with succeeded", () async {
        final initial = AsyncQueryResult<String>.pending();

        final future = Future.value(QueryResult.succeeded(value));
        final states = initial.updateWith(future);

        expect(
          states,
          emitsInOrder([
            AsyncQueryResult<String>.waiting(),
            AsyncQueryResult<String>.succeeded(value),
          ]),
        );
      });
      test("should update value with failed", () async {
        final initial = AsyncQueryResult<String>();

        final future = Future.value(QueryResult<String>.failed(error));
        final states = initial.updateWith(future);

        expect(
          states,
          emitsInOrder([
            AsyncQueryResult<String>.waiting(),
            AsyncQueryResult<String>.failed(error),
          ]),
        );
      });

      test("should complain when call on waiting", () async {
        final initial = AsyncQueryResult<String>.waiting();

        final future = Future.value(QueryResult.succeeded(value));

        final states = initial.updateWith(future);

        await expectLater(states, emitsError(isInstanceOf<StateError>()));
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
