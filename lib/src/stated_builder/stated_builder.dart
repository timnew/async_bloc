import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stated_result/stated_builder.dart';
import 'package:stated_result/stated_custom.dart';

import 'on_state.dart';

class StatedBuilder<TS extends Stated> extends StatelessWidget {
  final TS stated;
  final Widget? child;
  final List<OnState> stateBuilders;

  const StatedBuilder({
    Key? key,
    required this.stated,
    this.child,
    required this.stateBuilders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => stateBuilders
      .firstWhere(
        (b) => b.canBuild(stated),
        orElse: () => const OnState.unexpected(),
      )
      .build(context, stated, child);
}
