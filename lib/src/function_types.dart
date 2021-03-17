typedef TR ResultMapper<TR>();
typedef TR ValueResultMapper<T, TR>(T value);
typedef TR FailedResultMapper<TR>(dynamic error, StackTrace? stackTrace);
