import 'package:flutter/widgets.dart';
import 'widget_builders.dart';

/// Function to check whether given value is blank or not
typedef bool BlankChecker<T>(T value);

/// A builder handles blank content. It invokes [blankBuilder] when value given is blank.
/// Oherwise, [builder] will be used.
///
/// If is useful when [value] is nullable
/// Or using [ListView] or similar with [List] that could be empty.
class BlankableBuilder<T> extends StatelessWidget {
  /// The given value
  final T? value;

  /// Function used to determine whether [value] is blank or not
  final BlankChecker<T> blankChecker;

  /// Builder to be used when [value] is blank
  final WidgetBuilder blankBuilder;

  /// Builder to be used when [value] isn't blank
  final ValueResultBuilder builder;

  /// Create the widget
  ///
  /// [blankChecker] - Function used to determine whether [value] is blank or not
  /// If not given, [defaultBlankChecker] is used
  ///
  /// [blankBuilder] - Builder being used when [value] is blank
  /// If not given, [defaultBlankBuilder] is used.
  ///
  /// [builder] - Builder being used when [value] is not blank.
  /// The [value] passed to [builder] will never been `null`.
  BlankableBuilder({
    Key? key,
    required this.value,
    BlankChecker<T>? blankChecker,
    WidgetBuilder? blankBuilder,
    required this.builder,
  })   : this.blankChecker = blankChecker ?? defaultBlankChecker,
        this.blankBuilder = blankBuilder ?? defaultBlankBuilder,
        super(key: key);

  @override
  Widget build(BuildContext context) =>
      isValueBlank ? blankBuilder(context) : builder(context, value!);

  /// is [value] considered as blank or not
  bool get isValueBlank => value == null ? true : blankChecker(value!);

  /// Default blank checker.
  /// It supports [List], [Map], [Iterable], [String], by calling `isEmpty` on it.
  /// Otherwise, [UnsupportedError] is thrown.
  static bool defaultBlankChecker(dynamic value) {
    if (value is List) {
      return value.isEmpty;
    }

    if (value is Map) {
      return value.isEmpty;
    }

    if (value is Iterable) {
      return value.isEmpty;
    }

    if (value is String) {
      return value.isEmpty;
    }

    throw UnsupportedError(
      "Do not support blank check for type ${value.runtimeType}",
    );
  }

  /// Default blank builder
  /// It yields an empty [Container].
  static Widget defaultBlankBuilder(BuildContext context) => Container();
}
