import 'package:flutter/material.dart';
import 'package:timer_app/timer_controller.dart' show RunMode;

class BottomToolBar extends StatelessWidget {
  final bool isRunning;
  final RunMode mode;
  final VoidCallback onToggleRun;
  final VoidCallback onSwitchMode;
  final VoidCallback onReset;
  final VoidCallback onOpenSettings;

  const BottomToolBar({
    super.key,
    required this.isRunning,
    required this.mode,
    required this.onToggleRun,
    required this.onSwitchMode,
    required this.onReset,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // фон до самой нижней кромки
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 168, 173, 144),
                  Color.fromARGB(255, 125, 130, 104),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        // Контент над home-indicator
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ToolButton(
                  icon: isRunning
                      ? Icons.stop_rounded
                      : Icons.play_arrow_rounded,
                  label: isRunning ? 'Stop' : 'Start',
                  onTap: onToggleRun,
                ),

                _ToolButton(
                  icon: Icons.swap_horiz_rounded,
                  label: mode == RunMode.stopwatch ? 'Mode: SW' : 'Mode: Timer',
                  onTap: onSwitchMode,
                ),

                _ToolButton(
                  icon: Icons.refresh_rounded,
                  label: 'Reset',
                  onTap: onReset,
                ),
                _ToolButton(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  onTap: onOpenSettings,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 28,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: Colors.black87),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
