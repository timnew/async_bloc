import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

import '../custom_matchers.dart';

void main() {
  group("QueryResult", () {
    const value = "value";
    final error = "error";
    final stackTrace = StackTrace.empty;

    group("default constructor", () {
      final result = const QueryResult(value);

      test('should be a CompletedResult', () {
        expect(result, isInstanceOf<DoneValueState<String>>());
      });
      test('gives the same instance', () {
        expect(const QueryResult(value), same(result));
      });

      test("should have correct states", () {
        expect(result.isIdle, isFalse);
        expect(result.isWorking, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isTrue);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isTrue);
      });
    });

    group(".completed", () {
      final result = const QueryResult.completed(value);

      test('should be a CompletedResult', () {
        expect(result, isInstanceOf<DoneValueState<String>>());
      });
      test('gives the same instance', () {
        expect(const QueryResult(value), same(result));
      });

      test("should have correct states", () {
        expect(result.isIdle, isFalse);
        expect(result.isWorking, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isTrue);
        expect(result.isFailed, isFalse);
        expect(result.hasValue, isTrue);
        expect(result.asValue(), value);
      });
    });

    group(".failed", () {
      final result = QueryResult<String>.failed(error, stackTrace);

      test('should be a QueryResult<String>', () {
        expect(result, isInstanceOf<QueryResult<String>>());
      });

      test('should be an ErrorState', () {
        expect(result, isInstanceOf<ErrorState>());
      });

      test("should have correct states", () {
        expect(result.isIdle, isFalse);
        expect(result.isWorking, isFalse);
        expect(result.isFinished, isTrue);
        expect(result.isSucceeded, isFalse);
        expect(result.isFailed, isTrue);
        expect(result.hasValue, isFalse);
        expect(result.hasError, isTrue);
        expect(result.asError(), WithError(error));
        expect(result.asError(), WithStackTrace(stackTrace));
      });

      test('can create result without stacktrace', () {
        final result = QueryResult.failed(error);

        expect(result, WithError(error));
        expect(result, WithStackTrace(isNull));
      });
    });

    group(".from", () {
      final value = "value";
      final error = "error";
      final stackTrace = StackTrace.empty;

      final idle = IdleState();
      final idleValue = IdleValueState(value);
      final working = WorkingState();
      final workingValue = WorkingValueState(value);
      final failed = ErrorState(error, stackTrace);
      final failedValue = ErrorValueState(value, error, stackTrace);
      final done = DoneState();
      final doneValue = DoneValueState(value);

      test("idle", () {
        expect(() => QueryResult<String>.from(idle), throwsUnsupportedError);
      });

      test("idleValue", () {
        expect(
          () => QueryResult<String>.from(idleValue),
          throwsUnsupportedError,
        );
      });

      test("working", () {
        expect(() => QueryResult<String>.from(working), throwsUnsupportedError);
      });

      test("workingValue", () {
        expect(
          () => QueryResult<String>.from(workingValue),
          throwsUnsupportedError,
        );
      });

      test("error", () {
        final result = QueryResult<String>.from(failed);
        expect(result, isInstanceOf<QueryResult<String>>());
        expect(result, isInstanceOf<ErrorState>());
        expect(result, QueryResult.failed(error, stackTrace));
      });

      test("errorValue", () {
        final result = QueryResult<String>.from(failedValue);
        expect(result, isInstanceOf<QueryResult<String>>());
        expect(result, isInstanceOf<ErrorState>());
        expect(result, QueryResult.failed(error, stackTrace));
      });

      test("done", () {
        expect(() => QueryResult<String>.from(done), throwsUnsupportedError);
      });

      test("doneValue", () {
        final result = QueryResult<String>.from(doneValue);
        expect(result, isInstanceOf<QueryResult<String>>());
        expect(result, isInstanceOf<DoneValueState>());
        expect(result.asValue(), value);
      });
    });
  });

  group("QueryResultFutureExtension", () {
    final value = "value";
    final error = "error";

    group(".asQueryResult()", () {
      test("yields completed", () async {
        final result = Future.value(value).asQueryResult();
        await expectLater(result, completion(QueryResult.completed(value)));
      });

      test("yields failed", () async {
        final result = Future<String>.error(error).asQueryResult();

        await expectLater(
          result,
          completion(isInstanceOf<QueryResult<String>>()),
        );
        await expectLater(result, completion(isInstanceOf<ErrorState>()));
        await expectLater(result, completion(WithError(error)));
      });

      test("throws error", () async {
        final result = Future<String>.error(Error()).asQueryResult();

        await expectLater(
          result,
          throwsA(isInstanceOf<Error>()),
        );
      });
    });
  });
}
