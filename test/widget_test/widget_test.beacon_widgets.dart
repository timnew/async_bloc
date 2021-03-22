part of 'widget_test.dart';

class InitialWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

final findInitialWidget = find.byType(InitialWidget);

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Text("Empty");
}

final findEmptyWidget = find.byType(EmptyWidget);

class ErrorWidget extends StatelessWidget {
  final Object error;

  ErrorWidget(this.error);

  @override
  Widget build(BuildContext context) => Text("$error");
}

Finder findErrorWidget([dynamic? error]) => error == null
    ? find.byType(ErrorWidget)
    : find.widgetWithText(ErrorWidget, "$error");

class WaitingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}

final findWaitingWidget = find.byType(WaitingWidget);

class ContentWidget extends StatelessWidget {
  final String content;

  ContentWidget(this.content);

  @override
  Widget build(BuildContext context) => Text(content);
}

Finder findContentWidget([String? content]) => content == null
    ? find.byType(ContentWidget)
    : find.widgetWithText(ContentWidget, content);
