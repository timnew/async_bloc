import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/stated_builder.dart';
import 'package:stated_result/stated_value.dart';
import 'package:test_beacon/test_beacon.dart';

import '../custom_finders.dart';
import '../states.dart';

void main() {
  group("WorkingIndicatorBuilder", () {
    group(".custom builds", () {
      void createTest(String name, Stated stated) {
        testWidgets(name, (WidgetTester tester) async {
          await tester.pumpWidget(WorkingIndicatorBuilder.custom(
            stated: stated,
            builder: (_, b, c) => ContentBeacon(child: c, content: b),
            child: Beacon<String>(),
          ));

          find
              .contentBeacon(stated.isWorking)
              .shouldFindOne()
              .findChildBeacon<String>()
              .shouldFindOne();
        });
      }

      allStates.entries.forEach((e) => createTest(e.key, e.value));
    });

    group(".circular builds", () {
      void createTest(String name, Stated stated) {
        testWidgets(name, (WidgetTester tester) async {
          await tester.pumpWidget(
            WorkingIndicatorBuilder.circular(stated: stated),
          );

          findOpacity(stated.isWorking ? 1 : 0)
              .shouldFindOne()
              .findChild<CircularProgressIndicator>()
              .shouldFindOne();
        });
      }

      allStates.entries.forEach((e) => createTest(e.key, e.value));
    });

    group(".linear builds", () {
      void createTest(String name, Stated stated) {
        testWidgets(name, (WidgetTester tester) async {
          await tester.pumpWidgetOnScaffold(
            WorkingIndicatorBuilder.linear(stated: stated),
          );

          find.inTestScope
              .findChildBy(findOpacity(stated.isWorking ? 1 : 0))
              .shouldFindOne()
              .findChild<LinearProgressIndicator>()
              .shouldFindOne();
        });
      }

      allStates.entries.forEach((e) => createTest(e.key, e.value));
    });
  });
}
