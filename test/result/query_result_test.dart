import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

void main() {
  group("QueryResult", () {
    group("default constructor", () {
      final result = const QueryResult("value");

      test('should be a CompletedResult', () {
        expect(result, isInstanceOf<DoneValueState<String>>());
      });
      test('gives the same instance', () {
        expect(const QueryResult("value"), same(result));
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

      final result = QueryResult.failed(error, stackTrace);

      test('should be a FailedResult', () {
        expect(result, isInstanceOf<ErrorState>());
      });

      test('should contain error and stack trace', () {
        final failed = result as ErrorState;

        expect(failed.error, same(error));
        expect(failed.stackTrace, same(stackTrace));
      });

      test('can create result without stacktrace', () {
        final failed = QueryResult.failed(error) as ErrorState;

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

    group(".mapValue", () {
      test("should map success", () {
        final result = QueryResult<int>.succeeded(100);
        expect(
          result.mapValue((value) => value.toString()),
          QueryResult("100"),
        );
      });

      test("should map failed", () {
        final error = "error";
        final result = QueryResult<int>.failed(error);

        expect(
          result.mapValue((value) => value.toString()),
          QueryResult.failed(error),
        );
      });
    });
  });
}
