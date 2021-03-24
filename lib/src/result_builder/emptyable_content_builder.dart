import 'package:flutter/widgets.dart';
import 'package:stated_result/src/result_builder/default_empty_builder.dart';
import 'widget_builders.dart';

/// Contract to check whether the given [value] is considered as balnk
typedef bool EmptyChecker<T>(T value);

/// Contract for type can check whether it is empty or not
abstract class Emptyable {
  bool get isEmpty;
}

/// A builder handles blank content. It invokes [emptyBuilder] when value given is blank.
/// Oherwise, [builder] will be used.
///
/// If is useful when [content] is nullable
/// Or using [ListView] or similar with [List] that could be empty.
class EmptyableContentBuilder<T> extends StatelessWidget {
  /// The given value
  final T? content;

  /// Function used to determine whether [content] is blank or not
  final EmptyChecker<T> emptyChecker;

  /// Builder to be used when [content] is blank
  final WidgetBuilder? emptyBuilder;

  /// Builder to be used when [content] isn't blank
  final ValueResultBuilder<T> builder;

  /// Create the widget
  ///
  /// [emptyChecker] - Function used to determine whether [content] is blank or not
  /// If not given, [defaultEmptyChecker] is used
  ///
  /// [emptyBuilder] - Builder being used when [content] is blank
  /// If not given, [defaultEmptyBuilder] is used.
  ///
  /// [builder] - Builder being used when [content] is not blank.
  /// The [content] passed to [builder] will never been `null`.
  EmptyableContentBuilder({
    Key? key,
    required this.content,
    EmptyChecker<T>? emptyChecker,
    this.emptyBuilder,
    required this.builder,
  })   : this.emptyChecker = emptyChecker ?? defaultEmptyChecker,
        super(key: key);

  @override
  Widget build(BuildContext context) => isValueBlank
      ? DefaultEmptyBuilder.ensureBuild(context, emptyBuilder)
      : builder(context, content!);

  /// is [content] considered as blank or not
  bool get isValueBlank => content == null ? true : emptyChecker(content!);

  /// Default empty checker.
  /// It supports [Emptyable] [List], [Map], [Iterable], [String], by calling `isEmpty` on it.
  /// Otherwise, [UnsupportedError] is thrown.
  static bool defaultEmptyChecker(dynamic content) {
    if (content is Emptyable) {
      return content.isEmpty;
    }

    if (content is List) {
      return content.isEmpty;
    }

    if (content is Map) {
      return content.isEmpty;
    }

    if (content is Iterable) {
      return content.isEmpty;
    }

    if (content is String) {
      return content.isEmpty;
    }

    return false;
  }
}
