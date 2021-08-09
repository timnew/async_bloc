import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stated_result/stated.dart';

class StatedCubit<TS extends Stated> extends Cubit {
  StatedCubit(initialState) : super(initialState);
}
