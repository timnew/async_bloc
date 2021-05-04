import 'package:flutter_test/flutter_test.dart';
import 'package:test_beacon/test_beacon.dart';

enum _BeaconType {
  Pending,
  Empty,
  Waiting,
}

final findPendingBeacon = find.stateBeacon(_BeaconType.Pending);

final findEmptyBeacon = find.stateBeacon(_BeaconType.Empty);

final findWaitingBeacon = find.stateBeacon(_BeaconType.Waiting);

class PendingBeacon extends StateBeacon<_BeaconType> {
  PendingBeacon() : super(_BeaconType.Pending);
}

class WaitingBeacon extends StateBeacon<_BeaconType> {
  WaitingBeacon() : super(_BeaconType.Waiting);
}

class EmptyBeacon extends StateBeacon<_BeaconType> {
  EmptyBeacon() : super(_BeaconType.Empty);
}

Finder findErrorBeacon([dynamic error]) => find.errorBeacon(error);
Finder findContentBeacon([dynamic content]) =>
    find.contentBeacon<dynamic>(content);
