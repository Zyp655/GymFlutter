import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/cubits/sync/sync_cubit.dart';
import '../../presentation/cubits/sync/sync_state.dart';

class SyncIndicator extends StatelessWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncCubit, SyncState>(
      builder: (context, state) {
        if (state is SyncInProgress) {
          return _buildIndicator(
            context,
            icon: Icons.sync,
            color: Theme.of(context).colorScheme.primary,
            isAnimating: true,
            tooltip: 'Syncing...',
          );
        }

        if (state is SyncComplete && state.syncedCount > 0) {
          return _buildIndicator(
            context,
            icon: Icons.cloud_done,
            color: Colors.green,
            isAnimating: false,
            tooltip: 'Synced ${state.syncedCount} items',
          );
        }

        if (state is SyncError) {
          return _buildIndicator(
            context,
            icon: Icons.cloud_off,
            color: Theme.of(context).colorScheme.error,
            isAnimating: false,
            tooltip: 'Sync failed: ${state.message}',
            onTap: () => context.read<SyncCubit>().syncNow(),
          );
        }

        if (state is SyncIdle && state.pendingCount > 0) {
          return _buildIndicator(
            context,
            icon: Icons.cloud_upload,
            color: Theme.of(context).colorScheme.outline,
            isAnimating: false,
            tooltip: '${state.pendingCount} pending',
            badge: state.pendingCount,
            onTap: () => context.read<SyncCubit>().syncNow(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildIndicator(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required bool isAnimating,
    required String tooltip,
    int? badge,
    VoidCallback? onTap,
  }) {
    Widget iconWidget = Icon(icon, color: color, size: 20);

    if (isAnimating) {
      iconWidget = _RotatingIcon(icon: icon, color: color);
    }

    if (badge != null && badge > 0) {
      iconWidget = Badge.count(count: badge, child: iconWidget);
    }

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(padding: const EdgeInsets.all(8), child: iconWidget),
      ),
    );
  }
}

class _RotatingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;

  const _RotatingIcon({required this.icon, required this.color});

  @override
  State<_RotatingIcon> createState() => _RotatingIconState();
}

class _RotatingIconState extends State<_RotatingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: Icon(widget.icon, color: widget.color, size: 20),
        );
      },
    );
  }
}
