import 'package:stated_result/stated_result.dart';

import 'value_result.dart';

/// Mapper function for general result state
typedef TR ResultMapper<TR>();

/// Mapper function for result state with value
typedef TR ValueResultMapper<T, TR>(ValueResult<T> result);

/// Mapper fucntion for result state has error
typedef TR FailedResultMapper<TR>(FailedResult result);
