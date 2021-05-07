import 'package:stated_result/stated.dart';

const value = "value";
const exception = "exception";
const stackTrace = StackTrace.empty;

const idle = IdleState();
const idleValue = IdleValueState(value);
const working = WorkingState();
const workingValue = WorkingValueState(value);
const done = DoneState();
const doneValue = DoneValueState(value);
const error = ErrorState(exception, stackTrace);
const errorValue = ErrorValueState(value, exception, stackTrace);

const allStates = {
  "idle": idle,
  "idleValue": idleValue,
  "working": working,
  "workingValue": workingValue,
  "done": done,
  "doneValue": doneValue,
  "error": error,
  "errorValue": errorValue,
};
