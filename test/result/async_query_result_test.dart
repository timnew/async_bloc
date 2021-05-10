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
          expect(result.asValue(), value);
        });

        test("should have correct states", () {
          expect(result.isIdle, isTrue);
          expect(result.isWorking, isFalse);
          expect(result.isFinished, isFalse);
          expect(result.isSucceeded, isFalse);
          expect(result.isFailed, isFalse);
          expect(result.hasValue, isTrue);
          expect(result.asValue(), value);
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
        final result = AsyncQueryResult.completed(value);

        test("should be a CompletedResult", () {
          expect(result, isInstanceOf<DoneValueState<String>>());
        });

        test("should be a AsyncQueryResult", () {
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
        });

        test("should has value", () {
          final succeeded = result as DoneValueState<String>;
          expect(value, succeeded.value);
        });

        test("should have correct states", () {
          expect(result.isIdle, isFalse);
          expect(result.isWorking, isFalse);
          expect(result.isFinished, isTrue);
          expect(result.isSucceeded, isTrue);
          expect(result.isFailed, isFalse);
          expect(result.hasValue, isTrue);
          expect(result.asValue(), value);
          expect(result.hasError, isFalse);
        });
      });

      group(".failed", () {
        final result = AsyncQueryResult<String>.failed(exception, stackTrace);

        test("should be a FailedResult", () {
          expect(result, isInstanceOf<ErrorState>());
        });

        test("should be a AsyncQueryResult", () {
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
        });

        test("should contain error and stack trace", () {
          expect(result, WithError(exception));
          expect(result, WithStackTrace(stackTrace));
        });

        test("can create result without stacktrace", () {
          final result = AsyncQueryResult.failed(exception);

          expect(result, WithError(exception));
          expect(result, WithStackTrace(isNull));
        });

        test("should have correct states", () {
          expect(result.isIdle, isFalse);
          expect(result.isWorking, isFalse);
          expect(result.isFinished, isTrue);
          expect(result.isSucceeded, isFalse);
          expect(result.isFailed, isTrue);
          expect(result.hasValue, isFalse);
          expect(result.hasError, isTrue);
          expect(result.asError(), WithError(exception));
          expect(result.asError(), WithStackTrace(stackTrace));
        });
      });

      group(".fromValue", () {
        test("value is SucceededResult", () {
          final result = AsyncQueryResult.fromValue(value);
          expect(result, AsyncQueryResult.completed(value));
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
          expect(result, isInstanceOf<ErrorState>());
          expect(result, AsyncQueryResult.failed(exception, stackTrace));
        });

        test("errorValue", () {
          final result = AsyncQueryResult<String>.from(errorValue);
          expect(result, isInstanceOf<AsyncQueryResult<String>>());
          expect(result, isInstanceOf<ErrorState>());
          expect(result, AsyncQueryResult.failed(exception, stackTrace));
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
          expect(result, isInstanceOf<DoneValueState<String>>());
          expect(result, AsyncQueryResult<String>.completed(value));
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
            AsyncQueryResult<String>.completed(value),
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
              (s) => s.isFailed && s.asError().error == exception,
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
