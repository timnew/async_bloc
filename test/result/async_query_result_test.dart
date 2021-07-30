import "package:flutter_test/flutter_test.dart";
import "package:stated_result/stated_result.dart";

import '../custom_matchers.dart';
import '../states.dart';

void main() {
  group("AsyncQueryResult", () {
    group("factories", () {
      group("default constructor", () {
        final result = AsyncQueryResult<String>();

        test("should be an IdleState", () {
          expect(result, isInstanceOf<IdleState>());
        });

        test("should be a AsyncQueryResult", () {
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
        });

        test("returns a constant", () {
          expect(AsyncQueryResult<String>(), same(result));
        });

        test("should have correct states", () {
          expect(result.isIdle, isTrue);
          expect(result.isWorking, isFalse);
          expect(result.isFinished, isFalse);
          expect(result.isSucceeded, isFalse);
          expect(result.isFailed, isFalse);
          expect(result.hasValue, isFalse);
          expect(result.hasError, isFalse);
        });
      });

      group(".preset", () {
        final result = AsyncQueryResult<String>.preset(value);

        test("should be an IdleValueState", () {
          expect(result, isInstanceOf<IdleValueState<String>>());
        });
        test("should be a AsyncQueryResult", () {
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
        });
        test("should has value", () {
          expect(result.extractValue(), value);
        });

        test("should have correct states", () {
          expect(result.isIdle, isTrue);
          expect(result.isWorking, isFalse);
          expect(result.isFinished, isFalse);
          expect(result.isSucceeded, isFalse);
          expect(result.isFailed, isFalse);
          expect(result.hasValue, isTrue);
          expect(result.extractValue(), value);
          expect(result.hasError, isFalse);
        });
      });

      group(".working", () {
        final result = AsyncQueryResult<String>.working();

        test("should be a WaitingResult", () {
          expect(result, isInstanceOf<WorkingState>());
        });

        test("should be a AsyncQueryResult", () {
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
        });

        test("returns a constant", () {
          expect(AsyncQueryResult.working(), same(result));
        });

        test("should have correct states", () {
          expect(result.isIdle, isFalse);
          expect(result.isWorking, isTrue);
          expect(result.isFinished, isFalse);
          expect(result.isSucceeded, isFalse);
          expect(result.isFailed, isFalse);
          expect(result.hasValue, isFalse);
          expect(result.hasError, isFalse);
        });
      });

      group(".completed", () {
        final result = AsyncQueryResult.succeeded(value);

        test("should be a CompletedResult", () {
          expect(result, isInstanceOf<SucceededValueState<String>>());
        });

        test("should be a AsyncQueryResult", () {
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
        });

        test("should has value", () {
          final succeeded = result as SucceededValueState<String>;
          expect(value, succeeded.value);
        });

        test("should have correct states", () {
          expect(result.isIdle, isFalse);
          expect(result.isWorking, isFalse);
          expect(result.isFinished, isTrue);
          expect(result.isSucceeded, isTrue);
          expect(result.isFailed, isFalse);
          expect(result.hasValue, isTrue);
          expect(result.extractValue(), value);
          expect(result.hasError, isFalse);
        });
      });

      group(".failed", () {
        final result = AsyncQueryResult<String>.failed(exception);

        test("should be a FailedResult", () {
          expect(result, isInstanceOf<FailedState>());
        });

        test("should be a AsyncQueryResult", () {
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
        });

        test("should contain error and stack trace", () {
          expect(result, WithError(exception));
        });

        test("should have correct states", () {
          expect(result.isIdle, isFalse);
          expect(result.isWorking, isFalse);
          expect(result.isFinished, isTrue);
          expect(result.isSucceeded, isFalse);
          expect(result.isFailed, isTrue);
          expect(result.hasValue, isFalse);
          expect(result.hasError, isTrue);
          expect(result.extractError(), exception);
        });
      });

      group(".fromValue", () {
        test("value is SucceededResult", () {
          final result = AsyncQueryResult.fromValue(value);
          expect(result, AsyncQueryResult.succeeded(value));
        });

        test("null is PendingResult", () {
          final result = AsyncQueryResult.fromValue(null);
          expect(result, AsyncQueryResult.idle());
        });
      });

      group(".from", () {
        test("idle", () {
          final result = AsyncQueryResult<String>.from(idle);
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
          expect(result, isInstanceOf<IdleState>());
        });

        test("idleValue", () {
          final result = AsyncQueryResult<String>.from(idleValue);
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
          expect(result, isInstanceOf<IdleValueState<String>>());
          expect(result, AsyncQueryResult.preset(value));
        });

        test("working", () {
          final result = AsyncQueryResult<String>.from(working);
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
          expect(result, isInstanceOf<WorkingState>());
        });

        test("workingValue", () {
          final result = AsyncQueryResult<String>.from(workingValue);
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
          expect(result, isInstanceOf<WorkingState>());
        });

        test("eror", () {
          final result = AsyncQueryResult<String>.from(error);
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
          expect(result, isInstanceOf<FailedState>());
          expect(result, AsyncQueryResult.failed(exception));
        });

        test("errorValue", () {
          final result = AsyncQueryResult<String>.from(errorValue);
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
          expect(result, isInstanceOf<FailedState>());
          expect(result, AsyncQueryResult.failed(exception));
        });

        test("done", () {
          expect(
            () => AsyncQueryResult<String>.from(done),
            throwsUnsupportedError,
          );
        });

        test("doneValue", () {
          final result = AsyncQueryResult<String>.from(doneValue);
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
          expect(result, isInstanceOf<SucceededValueState<String>>());
          expect(result, AsyncQueryResult<String>.succeeded(value));
        });
      });
    });

    group(".updateWith", () {
      late List<AsyncQueryResult<String>> captured;

      setUp(() {
        captured = <AsyncQueryResult<String>>[];
      });

      test("should update value with succeeded", () async {
        final initial = AsyncQueryResult<String>.idle();
        final future = Future.value(value);

        await initial.updateWith(future, captured.add);

        expect(
          captured,
          containsAllInOrder([
            AsyncQueryResult<String>.working(),
            AsyncQueryResult<String>.succeeded(value),
          ]),
        );
      });

      test("should update value with failed", () async {
        final initial = AsyncQueryResult<String>();
        final future = Future<String>.error(exception);

        await initial.updateWith(future, captured.add);

        expect(
          captured,
          containsAllInOrder([
            AsyncQueryResult<String>.working(),
            predicate<AsyncQueryResult<String>>(
              (s) => s.isFailed && s.extractError() == exception,
              "is error",
            ),
          ]),
        );
      });

      test("should complain when call on waiting", () async {
        final initial = AsyncQueryResult<String>.working();
        final future = Future<String>.value(value);

        await expectLater(
          initial.updateWith(future, captured.add),
          throwsStateError,
        );
      });
    });
  });
}
