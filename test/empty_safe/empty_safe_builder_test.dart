import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stated_result/empty_safe.dart';
import 'package:test_beacon/test_beacon.dart';

void main() {
  group("EmptySafeBuilder", () {
    group("empty checker", () {
      Widget buildWidget<T>(T? content, [EmptyChecker<T>? checker]) =>
          EmptySafeBuilder(
            content: content,
            child: Beacon<String>(),
            emptyChecker: checker,
            emptyBuilder: (_, c) => Beacon<Null>(child: c),
            builder: (_, value, c) => ContentBeacon(content: value, child: c),
          );

      void runTest<T>(T emptyContent, T content, [EmptyChecker<T>? checker]) {
        testWidgets("is null", (WidgetTester tester) async {
          await tester.pumpWidget(buildWidget<T>(null, checker));

          find.beacon<Null>().shouldFindOne();
          find.contentBeacon().shouldFindNothing();
          find.beacon<String>().shouldFindOne();
        });

        testWidgets("is empty", (WidgetTester tester) async {
          await tester.pumpWidget(buildWidget(emptyContent, checker));

          find.beacon<Null>().shouldFindOne();
          find.contentBeacon().shouldFindNothing();
          find.beacon<String>().shouldFindOne();
        });

        testWidgets("is not empty", (WidgetTester tester) async {
          await tester.pumpWidget(buildWidget(content, checker));

          find.beacon<Null>().shouldFindNothing();
          find.contentBeacon(content).shouldFindOne();
          find.beacon<String>().shouldFindOne();
        });
      }

      group("default empty checker", () {
        group("list", () {
          runTest(const [], const [1, 2, 3]);
        });

        group("set", () {
          runTest(Set.of([]), Set.of([1, 2, 3]));
        });

        group("map", () {
          runTest<Map<String, String>>({}, {"a": "1"});
        });

        group("string", () {
          runTest("", "abc");
        });

        group("custom type", () {
          testWidgets("is null", (WidgetTester tester) async {
            await tester.pumpWidget(buildWidget<int>(null));

            find.beacon<Null>().shouldFindOne();
            find.contentBeacon().shouldFindNothing();
            find.beacon<String>().shouldFindOne();
          });

          testWidgets("not null", (WidgetTester tester) async {
            await tester.pumpWidget(buildWidget<int>(0));

            find.beacon<Null>().shouldFindNothing();
            find.contentBeacon(0).shouldFindOne();
            find.beacon<String>().shouldFindOne();
          });
        });
      });

      group("custom empty checker", () {
        final empty = 0;
        final notEmpty = 1;

        runTest(empty, notEmpty, (i) => i == empty);
      });
    });

    group("default empty builder", () {
      testWidgets("builds conainer when no child", (WidgetTester tester) async {
        await tester.pumpWidget(EmptySafeBuilder(
          content: null,
          builder: (_, value, c) => ContentBeacon(content: value, child: c),
        ));

        find.byType(Container).shouldFindOne();
      });

      testWidgets("builds child when child exists",
          (WidgetTester tester) async {
        await tester.pumpWidget(EmptySafeBuilder(
          content: null,
          child: Beacon<String>(),
          builder: (_, value, c) => ContentBeacon(content: value, child: c),
        ));

        find
            .beacon<String>()
            .shouldFindOne()
            .findAncestor<Container>()
            .shouldFindNothing();
      });
    });
  });
}
