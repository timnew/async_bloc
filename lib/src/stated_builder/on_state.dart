import 'package:flutter/widgets.dart';

import '../../stated_custom.dart';

typedef bool CanBuildPredict(Stated stated);

mixin CanBuild {
  static CanBuildPredict isType<TS extends Stated>() =>
      (stated) => stated is TS;

  static bool always(Stated stated) => true;

  static bool isIdle(Stated stated) => stated.isIdle;

  static bool isWorking(Stated stated) => stated.isWorking;

  static bool isFailed(Stated stated) => stated.isFailed;

  static bool isSuceeded(Stated stated) => stated.isSucceeded;

  static bool isFinished(Stated stated) => stated.isFinished;

  static bool isHasValue(Stated stated) => stated is HasValue;

  static bool isHasError(Stated stated) => stated is HasError;

  static bool isHasValueAndError(Stated stated) => stated is HasValueAndError;
}

abstract class OnState<T> {
  final CanBuildPredict canBuild;

  const OnState(this.canBuild);

  Widget build(BuildContext context, Stated stated, Widget? child);

  const factory OnState.unexpected({CanBuildPredict criteria}) = _Unexpected;

  const factory OnState.unit(
    TransitionBuilder builder, {
    required CanBuildPredict criteria,
  }) = _Unit;

  const factory OnState.value(
    ValueWidgetBuilder<T> builder, {
    CanBuildPredict criteria,
  }) = _Value;

  const factory OnState.error(
    ValueWidgetBuilder<Object> builder, {
    CanBuildPredict criteria,
  }) = _Error;

  const factory OnState.valueError(
    ValueWidgetBuilder<HasValueAndError<T>> builder, {
    CanBuildPredict criteria,
  }) = _ValueError;

  const factory OnState.custom(
    ValueWidgetBuilder<Stated> builder, {
    required CanBuildPredict criteria,
  }) = _Custom;
}

class _Unexpected extends OnState<Never> {
  const _Unexpected({CanBuildPredict criteria = CanBuild.always})
      : super(criteria);

  @override
  Widget build(BuildContext context, Stated stated, Widget? child) =>
      throw StateError("Unexpected State $stated");
}

class _Unit extends OnState<Never> {
  final TransitionBuilder builder;

  const _Unit(this.builder, {required CanBuildPredict criteria})
      : super(criteria);

  @override
  Widget build(BuildContext context, Stated stated, Widget? child) =>
      builder(context, child);
}

class _Value<T> extends OnState<T> {
  final ValueWidgetBuilder<T> builder;

  const _Value(this.builder, {CanBuildPredict criteria = CanBuild.isHasValue})
      : super(criteria);

  @override
  Widget build(BuildContext context, Stated stated, Widget? child) =>
      builder(context, stated.extractValue(), child);
}

class _Error extends OnState<Never> {
  final ValueWidgetBuilder<Object> builder;

  const _Error(this.builder, {CanBuildPredict criteria = CanBuild.isHasError})
      : super(criteria);

  @override
  Widget build(BuildContext context, Stated stated, Widget? child) =>
      builder(context, stated.extractError(), child);
}

class _ValueError<T> extends OnState<T> {
  final ValueWidgetBuilder<HasValueAndError<T>> builder;

  const _ValueError(this.builder,
      {CanBuildPredict criteria = CanBuild.isHasValueAndError})
      : super(criteria);

  @override
  Widget build(BuildContext context, Stated stated, Widget? child) =>
      builder(context, stated as HasValueAndError<T>, child);
}

class _Custom extends OnState<Never> {
  final ValueWidgetBuilder<Stated> builder;

  const _Custom(this.builder, {required CanBuildPredict criteria})
      : super(criteria);

  @override
  Widget build(BuildContext context, Stated stated, Widget? child) =>
      builder(context, stated, child);
}
