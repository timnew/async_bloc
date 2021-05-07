import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

import '../custom_matchers.dart';

void main() {
  group("ActionResult", () {
    final value = "value";
    final error = "error";
    final stackTrace = StackTrace.empty;

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
        expect(result.isWorking, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isTrue);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isFalse);
      });
    });

    group(".failed", () {
      final result = ActionResult.failed(error, stackTrace);

      test('should be a FailedResult', () {
        expect(result, isInstanceOf<ErrorState>());
      });

      test('should contain error and stack trace', () {
        expect(result, WithError(error));
        expect(result, WithStackTrace(stackTrace));
      });

      test('can create result without stacktrace', () {
        final result = ActionResult.failed(error);

        expect(result, WithError(error));
        expect(result, WithStackTrace(isNull));
      });

      test("should have correct states", () {
        expect(result.isIdle, isFalse);
        expect(result.isWorking, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isTrue);
        expect(result.hasValue, isFalse);
        expect(result.asError(), WithError(error));
        expect(result.asError(), WithStackTrace(stackTrace));
      });
    });

    group(".from", () {
      final idle = IdleState();
      final idleValue = IdleValueState(value);
      final working = WorkingState();
      final workingValue = WorkingValueState(value);
      final failed = ErrorState(error, stackTrace);
      final failedValue = ErrorValueState(value, error, stackTrace);
      final done = DoneState();
      final doneValue = DoneValueState(value);

      test("idle", () {
        expect(() => ActionResult.from(idle), throwsUnsupportedError);
      });

      test("idleValue", () {
        expect(() => ActionResult.from(idleValue), throwsUnsupportedError);
      });

      test("working", () {
        expect(() => ActionResult.from(working), throwsUnsupportedError);
      });

      test("workingValue", () {
        expect(() => ActionResult.from(workingValue), throwsUnsupportedError);
      });

      test("failed", () {
        final result = ActionResult.from(failed);
        expect(result, isInstanceOf<ActionResult>());
        expect(result, isInstanceOf<ErrorState>());
        expect(result, ActionResult.failed(error, stackTrace));
      });

      test("failedValue", () {
        final result = ActionResult.from(failedValue);

        expect(result, isInstanceOf<ActionResult>());
        expect(result, isInstanceOf<ErrorState>());
        expect(result, ActionResult.failed(error, stackTrace));
      });

      test("done", () {
        final result = ActionResult.from(done);
        expect(result, isInstanceOf<ActionResult>());
        expect(result, isInstanceOf<DoneState>());
      });

      test("doneValue", () {
        final result = ActionResult.from(doneValue);
        expect(result, isInstanceOf<ActionResult>());
        expect(result, isInstanceOf<DoneState>());
      });
    });
  });

  group("ActionResultFutureExtension", () {
    final value = "value";
    final error = "error";

    group(".asActionResult()", () {
      group("Future<T>", () {
        test("runs", () async {
          final result = await Future.value(value).asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<DoneState>());
        });

        test("yields error", () async {
          final result = await Future.error(error).asActionResult();
          expect(result, isInstanceOf<ActionResult>());
          expect(result, isInstanceOf<ErrorState>());
          expect(result.asError().error, error);
        });
      });

      group("Future<Stated>", () {
        test("yields IdleState", () async {
          final future = Future.value(IdleState());

          await expectLater(
            future.asActionResult(),
            throwsUnsupportedError,
          );
        });

        test("yields IdleValueState", () async {
          final future = Future.value(IdleValueState(value));

          await expectLater(
            future.asActionResult(),
            throwsUnsupportedError,
          );
        });

        test("yields WorkingState", () async {
          final future = Future.value(WorkingState());

          await expectLater(
            future.asActionResult(),
            throwsUnsupportedError,
          );
        });

        test("yields WorkingValueState", () async {
          final future = Future.value(WorkingValueState(value));

          await expectLater(
            future.asActionResult(),
            throwsUnsupportedError,
          );
        });

        test("yields DoneState", () async {
          final future = Future.value(DoneState());

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<ActionResult>()),
          );

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<DoneState>()),
          );
        });

        test("yields DoneValueState", () async {
          final future = Future.value(DoneValueState(value));

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<ActionResult>()),
          );

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<DoneState>()),
          );
        });

        test("yields ErrorState", () async {
          final future = Future.value(ErrorState(error));

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<ActionResult>()),
          );

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<ErrorState>()),
          );

          await expectLater(
            future.asActionResult(),
            completion(WithError(error)),
          );
        });

        test("yields ErrorValueState", () async {
          final future = Future.value(ErrorValueState(value, error));

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<ActionResult>()),
          );

          await expectLater(
            future.asActionResult(),
            completion(isInstanceOf<ErrorState>()),
          );

          await expectLater(
            future.asActionResult(),
            completion(WithError(error)),
          );
        });
      });
    });
  });
}
