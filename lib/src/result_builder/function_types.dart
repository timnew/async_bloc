import 'package:flutter/widgets.dart';

typedef Widget FailedResultBuilder(
  BuildContext context,
  dynamic error,
  StackTrace? stackTrace,
);

typedef Widget ValueResultBuilder<T>(BuildContext context, T value);
