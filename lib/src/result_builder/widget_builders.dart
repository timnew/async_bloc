import 'package:flutter/widgets.dart';
import 'package:stated_result/stated_result.dart';

typedef Widget FailedResultBuilder(
    BuildContext context, ErrorWithStack errorWithStack);

typedef Widget ValueResultBuilder<T>(BuildContext context, T value);
