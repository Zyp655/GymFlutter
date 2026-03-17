import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityCubit({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity(),
      super(ConnectivityInitial());

  void startMonitoring() {
    _checkConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
  }

  Future<void> _checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _onConnectivityChanged(results);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      emit(DisconnectedState());
    } else {
      emit(ConnectedState());
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
