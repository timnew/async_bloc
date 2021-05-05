import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_result.dart';

void main() {
  group("<T extends StatedResult>.from", () {
    final value = "value";
    final error = "error";
    final stackTrace = StackTrace.empty;

    final pending = AsyncQueryResult.pending();
    final initialValue = AsyncQueryResult.initialValue(value);
    final waiting = AsyncQueryResult.waiting();
    final failed = AsyncQueryResult.failed(error, stackTrace);
    final succeded = AsyncQueryResult.succeeded(value);
    final completed = AsyncActionResult.completed();

    group("ActionResult", () {
      test(".from(pendingResult)", () {
        expect(() => ActionResult.from(pending), throwsUnsupportedError);
      });

      test(".from(initialValue)", () {
        expect(() => ActionResult.from(initialValue), throwsUnsupportedError);
      });

      test(".from(waiting)", () {
        expect(() => ActionResult.from(waiting), throwsUnsupportedError);
      });

      test(".from(failed)", () {
        final result = ActionResult.from(failed);
        expect(result, isInstanceOf<ActionResult>());
        expect(result, isInstanceOf<ErrorState>());
        expect(result, ActionResult.failed(error, stackTrace));
      });

      test(".from(succeded)", () {
        final result = ActionResult.from(succeded);
        expect(result, isInstanceOf<ActionResult>());
        expect(result, isInstanceOf<DoneState>());
      });

      test(".from(completed)", () {
        final result = ActionResult.from(completed);
        expect(result, isInstanceOf<ActionResult>());
        expect(result, isInstanceOf<DoneState>());
      });
    });

    group("QueryResult", () {
      test(".from(pendingResult)", () {
        expect(() => QueryResult<String>.from(pending), throwsUnsupportedError);
      });

      test(".from(initialValue)", () {
        final result = QueryResult<String>.from(initialValue);
        expect(result, isInstanceOf<QueryResult<String>>());
        expect(result, isInstanceOf<HasValue<String>>());
        expect(result, QueryResult<String>.succeeded(value));
      });

      test(".from(waiting)", () {
        expect(() => QueryResult<String>.from(waiting), throwsUnsupportedError);
      });

      test(".from(failed)", () {
        final result = QueryResult<String>.from(failed);
        expect(result, isInstanceOf<QueryResult<String>>());
        expect(result, isInstanceOf<ErrorState>());
        expect(result, QueryResult.failed(error, stackTrace));
      });

      test(".from(succeded)", () {
        final result = QueryResult<String>.from(succeded);
        expect(result, isInstanceOf<QueryResult<String>>());
        expect(result, isInstanceOf<DoneValueState>());
        expect(result, QueryResult<String>.succeeded(value));
      });

      test(".from(completed)", () {
        expect(
            () => QueryResult<String>.from(completed), throwsUnsupportedError);
      });
    });
    group("AsyncActionResult", () {
      test(".from(pendingResult)", () {
        final result = AsyncActionResult.from(pending);
        expect(result, isInstanceOf<AsyncActionResult>());
        expect(result, isInstanceOf<IdleState>());
      });

      test(".from(initialValue)", () {
        final result = AsyncActionResult.from(initialValue);
        expect(result, isInstanceOf<AsyncActionResult>());
        expect(result, isInstanceOf<IdleState>());
      });

      test(".from(waiting)", () {
        final result = AsyncActionResult.from(waiting);
        expect(result, isInstanceOf<AsyncActionResult>());
        expect(result, isInstanceOf<WaitingState>());
      });

      test(".from(failed)", () {
        final result = AsyncActionResult.from(failed);
        expect(result, isInstanceOf<AsyncActionResult>());
        expect(result, isInstanceOf<ErrorState>());
        expect(result, AsyncActionResult.failed(error, stackTrace));
      });

      test(".from(succeded)", () {
        final result = AsyncActionResult.from(succeded);
        expect(result, isInstanceOf<AsyncActionResult>());
        expect(result, isInstanceOf<DoneState>());
      });

      test(".from(completed)", () {
        final result = AsyncActionResult.from(completed);
        expect(result, isInstanceOf<AsyncActionResult>());
        expect(result, isInstanceOf<DoneState>());
      });
    });

    group("AsyncQueryResult", () {
      test(".from(pendingResult)", () {
        final result = AsyncQueryResult<String>.from(pending);
        expect(result, isInstanceOf<AsyncQueryResult<String>>());
        expect(result, isInstanceOf<IdleState>());
      });

      test(".from(initialValue)", () {
        final result = AsyncQueryResult<String>.from(initialValue);
        expect(result, isInstanceOf<AsyncQueryResult<String>>());
        expect(result, isInstanceOf<IdleValueState<String>>());
        expect(result, AsyncQueryResult.initialValue(value));
      });

      test(".from(waiting)", () {
        final result = AsyncQueryResult<String>.from(waiting);
        expect(result, isInstanceOf<AsyncQueryResult<String>>());
        expect(result, isInstanceOf<WaitingState>());
      });

      test(".from(failed)", () {
        final result = AsyncQueryResult<String>.from(failed);
        expect(result, isInstanceOf<AsyncQueryResult<String>>());
        expect(result, isInstanceOf<ErrorState>());
        expect(result, AsyncQueryResult.failed(error, stackTrace));
      });

      test(".from(succeded)", () {
        final result = AsyncQueryResult<String>.from(succeded);
        expect(result, isInstanceOf<AsyncQueryResult<String>>());
        expect(result, isInstanceOf<DoneValueState<String>>());
        expect(result, AsyncQueryResult<String>.succeeded(value));
      });

      test(".from(completed)", () {
        expect(() => AsyncQueryResult<String>.from(completed),
            throwsUnsupportedError);
      });
    });
  });
}
