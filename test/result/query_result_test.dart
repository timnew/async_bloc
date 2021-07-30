import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

import '../custom_matchers.dart';
import '../states.dart';

void main() {
  group("QueryResult", () {
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
        expect(result.extractValue(), value);
      });
    });

    group(".failed", () {
      final result = QueryResult<String>.failed(exception);

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
        expect(result.extractError(), exception);
      });
    });

    group(".from", () {
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
        final result = QueryResult<String>.from(error);
        expect(result, isInstanceOf<QueryResult<String>>());
        expect(result, isInstanceOf<ErrorState>());
        expect(result, QueryResult.failed(exception));
      });

      test("errorValue", () {
        final result = QueryResult<String>.from(errorValue);
        expect(result, isInstanceOf<QueryResult<String>>());
        expect(result, isInstanceOf<ErrorState>());
        expect(result, QueryResult.failed(exception));
      });

      test("done", () {
        expect(() => QueryResult<String>.from(done), throwsUnsupportedError);
      });

      test("doneValue", () {
        final result = QueryResult<String>.from(doneValue);
        expect(result, isInstanceOf<QueryResult<String>>());
        expect(result, isInstanceOf<DoneValueState>());
        expect(result.extractValue(), value);
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
