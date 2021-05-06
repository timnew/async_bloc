import 'package:flutter/widgets.dart';

/// Fuction returns `true` if `value` is empty
typedef bool EmptyChekcer<T>(T value);

/// A builder widget invoke different builder based on whether value is empty or not.
///
/// If is useful when [content] is nullable
/// Or used to wrap widgets like [ListView] doesn't support empty list.
class EmptySafeBuilder<T> extends StatelessWidget {
  /// The given content
  final T? content;

  /// Prebuild child widget
  final Widget? child;

  /// Function used to determine whether [content] is empty or not
  final EmptyChekcer<T> emptyChecker;

  /// Builder to be used when [content] is empty
  final TransitionBuilder emptyBuilder;

  /// Builder to be used when [content] isn't empty
  final ValueWidgetBuilder<T> builder;

  /// Create the widget
  ///
  /// [emptyChecker] - Function used to determine whether [content] is blank or not
  /// If not given, [defaultEmptyChecker] is used, which support `Map` `Iterable` and `String`
  ///
  /// [emptyBuilder] - Builder being used when [content] is blank
  /// If not given, [defaultEmptyBuilder] is used, which returns `child` or empty `Container` when `child` is `null`.
  ///
  /// [builder] - Builder being used when [content] is not blank.
  /// The [content] passed to [builder] will never been `null`.
  EmptySafeBuilder({
    Key? key,
    required this.content,
    EmptyChekcer<T>? emptyChecker,
    this.child,
    TransitionBuilder? emptyBuilder,
    required this.builder,
  })  : this.emptyChecker = emptyChecker ?? defaultEmptyChecker,
        this.emptyBuilder = emptyBuilder ?? defaultEmptyBuilder,
        super(key: key);

  @override
  Widget build(BuildContext context) => isEmpty
      ? emptyBuilder(context, child)
      : builder(context, content!, child);

  /// Check is [content] empty or not
  bool get isEmpty => content == null ? true : emptyChecker(content!);

  /// Default empty checker.
  /// It supports [Iterable],[Map] or [String].
  /// Otherwise, [UnsupportedError] is thrown.
  static bool defaultEmptyChecker(dynamic content) {
    if (content is Iterable) {
      return content.isEmpty;
    }

    if (content is Map) {
      return content.isEmpty;
    }

    if (content is String) {
      return content.isEmpty;
    }

    return false;
  }

  /// Default empty builder
  /// Returns `child` or an empty `Container`
  static Widget defaultEmptyBuilder(BuildContext context, Widget? child) =>
      child ?? Container();
}
