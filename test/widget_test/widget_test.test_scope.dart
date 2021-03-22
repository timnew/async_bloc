part of 'widget_test.dart';

enum TestBenchType {
  Material,
  Cupertino,
}

/// Widget provides [TestScope] with [Scaffold]
class TestBench extends StatelessWidget {
  final TestBenchType type;
  final Widget child;

  TestBench({
    this.type = TestBenchType.Material,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => _buildApp(
        child: TestScope(child: child),
      );

  Widget _buildApp({required Widget child}) {
    switch (type) {
      case TestBenchType.Material:
        return _buildMatrialApp(child: child);
      case TestBenchType.Cupertino:
        return _buildCupertino(child: child);
    }
  }

  Widget _buildMatrialApp({required Widget child}) => MaterialApp(
        home: Scaffold(
          body: child,
        ),
      );

  Widget _buildCupertino({required Widget child}) => CupertinoApp(
        home: CupertinoPageScaffold(
          child: child,
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
