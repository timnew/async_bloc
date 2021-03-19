/// Mapper function for general result state
typedef TR ResultMapper<TR>();

/// Mapper function for result state with value
typedef TR ValueResultMapper<T, TR>(T value);

/// Mapper fucntion for result state has error
typedef TR FailedResultMapper<TR>(dynamic error, StackTrace? stackTrace);
