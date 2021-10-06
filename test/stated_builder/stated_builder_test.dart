import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_builder.dart';
import 'package:test_beacon/test_beacon.dart';

import 'test_stated.dart';

void main() {
  group("StatedBuilder", () {
    Future buildWidget(WidgetTester tester, TestStated stated,
        [Widget? child]) async {
      await tester.pumpWidget(
        StatedBuilder(
          stated: stated,
          patternDefs: (b) => b
            ..unit(OnState<TestUnitState>(),
                (context, child) => Beacon<TestUnitState>(child: child))
            ..value(
              OnState<TestValueState>(),
              (context, value, child) =>
                  ContentBeacon(content: value, child: child),
            )
            ..error(
              OnState<TestErrorState>(),
              (context, error, child) => ErrorBeacon(
                error: error,
                child: child,
              ),
            )
            ..unit(
              OnState<TestStated>.isSuceeded(),
              (context, child) => Beacon<SucceededState>(child: child),
            ),
          child: child,
        ),
      );
    }

    group('it should build', () {
      final child = Beacon<Widget>();
      final value = "value";
      final error = "error";

      testWidgets(".unit", (WidgetTester tester) async {
        await buildWidget(tester, TestStated.unit(), child);
        find
            .beacon<TestUnitState>()
            .shouldFindOne()
            .findChildBeacon<Widget>()
            .shouldFindOne();

        find.contentBeacon().shouldFindNothing();
        find.errorBeacon().shouldFindNothing();
        find.beacon<SucceededState>().shouldFindNothing();
      });

      testWidgets(".value", (WidgetTester tester) async {
        await buildWidget(tester, TestStated.value(value), child);

        find.beacon<TestUnitState>().shouldFindNothing();
        find
            .contentBeacon(value)
            .shouldFindOne()
            .findChildBeacon<Widget>()
            .shouldFindOne();
        find.errorBeacon().shouldFindNothing();
        find.beacon<SucceededState>().shouldFindNothing();
      });

      testWidgets(".error", (WidgetTester tester) async {
        await buildWidget(tester, TestStated.error(error), child);

        find.beacon<TestUnitState>().shouldFindNothing();
        find.contentBeacon().shouldFindNothing();
        find
            .errorBeacon(error)
            .shouldFindOne()
            .findChildBeacon<Widget>()
            .shouldFindOne();
        find.beacon<SucceededState>().shouldFindNothing();
      });

      testWidgets(".succeeded", (WidgetTester tester) async {
        await buildWidget(tester, TestStated.succeeded(), child);

        find.beacon<TestUnitState>().shouldFindNothing();
        find.contentBeacon().shouldFindNothing();
        find.errorBeacon().shouldFindNothing();
        find
            .beacon<SucceededState>()
            .shouldFindOne()
            .findChildBeacon<Widget>()
            .shouldFindOne();
      });
    });
  });
}
