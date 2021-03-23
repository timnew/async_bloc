part of 'widget_tester.dart';

class PendingBeacon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}

final findPendingBeacon = find.byType(PendingBeacon);

class EmptyBeacon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}

final findEmptyBeacon = find.byType(EmptyBeacon);

class ErrorBeacon extends StatelessWidget {
  final dynamic error;

  ErrorBeacon(this.error);

  @override
  Widget build(BuildContext context) => Text("$error");
}

Finder findErrorBeacon([dynamic? error]) => error == null
    ? find.byType(ErrorBeacon)
    : find.widgetWithText(ErrorBeacon, "$error");

class WaitingBeacon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}

final findWaitingBeacon = find.byType(WaitingBeacon);

class ContentBeacon extends StatelessWidget {
  final dynamic? content;

  ContentBeacon([this.content]);

  @override
  Widget build(BuildContext context) =>
      content == null ? Container() : Text("$content");
}

Finder findContentBeacon([String? content]) => content == null
    ? find.byType(ContentBeacon)
    : find.widgetWithText(ContentBeacon, content);
