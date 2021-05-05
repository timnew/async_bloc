import 'package:flutter/widgets.dart';
import 'package:stated_result/stated_result.dart';

/// Widget builder that accepts an error/exception with its optional stack trace
typedef Widget FailedResultBuilder(BuildContext context, HasError errorInfo);

/// Widget builder that accepts a given value but without child
typedef Widget ValueResultBuilder<T>(BuildContext context, T value);
