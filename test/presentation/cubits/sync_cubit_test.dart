import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btlmobile/data/services/sync_service.dart';
import 'package:btlmobile/presentation/cubits/sync/sync_cubit.dart';
import 'package:btlmobile/presentation/cubits/sync/sync_state.dart';

class MockSyncService extends Mock implements SyncService {}

void main() {
  late MockSyncService mockSyncService;
  late SyncCubit cubit;

  setUp(() {
    mockSyncService = MockSyncService();
    cubit = SyncCubit(syncService: mockSyncService);
  });

  tearDown(() {
    cubit.close();
  });

  group('SyncCubit', () {
    test('initial state is SyncIdle', () {
      expect(cubit.state, isA<SyncIdle>());
    });

    blocTest<SyncCubit, SyncState>(
      'syncNow emits [SyncInProgress, SyncComplete] on success',
      build: () {
        when(() => mockSyncService.syncPendingChanges()).thenAnswer(
          (_) async =>
              SyncResult(success: true, syncedCount: 3, failedCount: 0),
        );
        when(() => mockSyncService.pullFromCloud()).thenAnswer(
          (_) async =>
              SyncResult(success: true, syncedCount: 1, failedCount: 0),
        );
        when(
          () => mockSyncService.getPendingCount(),
        ).thenAnswer((_) async => 0);
        return cubit;
      },
      act: (cubit) => cubit.syncNow(),
      wait: const Duration(seconds: 3),
      expect: () => [
        isA<SyncInProgress>(),
        isA<SyncComplete>()
            .having((s) => s.syncedCount, 'synced', 4)
            .having((s) => s.failedCount, 'failed', 0),
      ],
    );

    blocTest<SyncCubit, SyncState>(
      'syncNow emits [SyncInProgress, SyncError] on failure',
      build: () {
        when(
          () => mockSyncService.syncPendingChanges(),
        ).thenThrow(Exception('Network error'));
        when(
          () => mockSyncService.getPendingCount(),
        ).thenAnswer((_) async => 0);
        return cubit;
      },
      act: (cubit) => cubit.syncNow(),
      wait: const Duration(seconds: 4),
      expect: () => [isA<SyncInProgress>(), isA<SyncError>()],
    );

    blocTest<SyncCubit, SyncState>(
      'syncNow skips if already in progress',
      build: () => cubit,
      seed: () => const SyncInProgress(),
      act: (cubit) => cubit.syncNow(),
      expect: () => [],
    );
  });
}
