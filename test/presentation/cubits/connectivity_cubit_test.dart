import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btlmobile/presentation/cubits/connectivity/connectivity_cubit.dart';
import 'package:btlmobile/presentation/cubits/connectivity/connectivity_state.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late MockConnectivity mockConnectivity;
  late ConnectivityCubit cubit;
  late StreamController<List<ConnectivityResult>> streamController;

  setUp(() {
    mockConnectivity = MockConnectivity();
    streamController = StreamController<List<ConnectivityResult>>.broadcast();

    when(
      () => mockConnectivity.onConnectivityChanged,
    ).thenAnswer((_) => streamController.stream);
  });

  tearDown(() {
    cubit.close();
    streamController.close();
  });

  group('ConnectivityCubit', () {
    test('initial state is ConnectivityInitial', () {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      cubit = ConnectivityCubit(connectivity: mockConnectivity);
      expect(cubit.state, isA<ConnectivityInitial>());
    });

    test('startMonitoring emits ConnectedState when wifi', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      cubit = ConnectivityCubit(connectivity: mockConnectivity);
      cubit.startMonitoring();

      await Future.delayed(const Duration(milliseconds: 100));

      expect(cubit.state, isA<ConnectedState>());
    });

    test('startMonitoring emits DisconnectedState when none', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.none]);

      cubit = ConnectivityCubit(connectivity: mockConnectivity);
      cubit.startMonitoring();

      await Future.delayed(const Duration(milliseconds: 100));

      expect(cubit.state, isA<DisconnectedState>());
    });

    test('responds to connectivity changes via stream', () async {
      when(
        () => mockConnectivity.checkConnectivity(),
      ).thenAnswer((_) async => [ConnectivityResult.wifi]);

      cubit = ConnectivityCubit(connectivity: mockConnectivity);
      cubit.startMonitoring();

      await Future.delayed(const Duration(milliseconds: 100));
      expect(cubit.state, isA<ConnectedState>());

      streamController.add([ConnectivityResult.none]);
      await Future.delayed(const Duration(milliseconds: 100));
      expect(cubit.state, isA<DisconnectedState>());

      streamController.add([ConnectivityResult.mobile]);
      await Future.delayed(const Duration(milliseconds: 100));
      expect(cubit.state, isA<ConnectedState>());
    });
  });
}
