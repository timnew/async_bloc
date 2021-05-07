import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

Finder findOpacity(double opacity) => find.byWidgetPredicate(
      (widget) =>
          (widget is AnimatedOpacity && widget.opacity == opacity) ||
          (widget is Opacity && widget.opacity == opacity),
    );
