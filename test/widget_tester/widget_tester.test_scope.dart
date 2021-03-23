part of 'widget_tester.dart';

/// Widget provides [TestScope] with [Scaffold]
class TestBench extends StatelessWidget {
  final Widget child;

  TestBench({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          body: TestScope(child: child),
        ),
      );
}

/// Beacon Widget to identify the test boundry in widget tree
class TestScope extends StatelessWidget {
  final Widget child;

  const TestScope({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => child;
}

/// find Widget in test
final findInTestScope = find.byType(TestScope);
