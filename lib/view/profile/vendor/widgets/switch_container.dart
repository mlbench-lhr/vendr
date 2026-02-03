import 'package:flutter/material.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';

class SwitchContainer extends StatefulWidget {
  final String name; // Label or name
  final bool switchValue; // Initial switch value
  final String? activeValue; // Text to show when switch is ON
  final String? inactiveValue; // Text to show when switch is OFF
  final Function(bool) onStatusChanged;
  final bool isEnabled; // Control if switch is enabled

  const SwitchContainer({
    super.key,
    required this.name,
    required this.switchValue,
    required this.activeValue,
    required this.inactiveValue,
    required this.onStatusChanged,
    this.isEnabled = true, // default is enabled
  });

  @override
  _SwitchContainerState createState() => _SwitchContainerState();
}

class _SwitchContainerState extends State<SwitchContainer> {
  late bool switchValue;

  @override
  void initState() {
    super.initState();
    switchValue = widget.switchValue; // Initialize with parent-provided value
  }

  @override
  void didUpdateWidget(covariant SwitchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync with parent when value changes externally
    if (oldWidget.switchValue != widget.switchValue) {
      setState(() {
        switchValue = widget.switchValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Disabled text color
    final textColor = widget.isEnabled ? Colors.white : Colors.grey.shade400;

    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.inputBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${widget.name}${switchValue ? widget.activeValue : widget.inactiveValue}",
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          Switch(
            value: switchValue,
            onChanged: widget.isEnabled
                ? (value) {
                    setState(() {
                      switchValue = value;
                    });
                    widget.onStatusChanged(value);
                    debugPrint('Is ${widget.name} Switched: $switchValue');
                  }
                : null, // disable switch if isEnabled is false

            thumbIcon: WidgetStateProperty.all(const Icon(null)),

            trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
              states,
            ) {
              if (states.contains(WidgetState.selected)) {
                return widget.isEnabled ? Colors.blue : Colors.grey.shade400;
              }
              return Colors.transparent;
            }),

            activeColor: widget.isEnabled ? Colors.white : Colors.grey.shade400,
            activeTrackColor: widget.isEnabled ? Colors.blue : Colors.grey,
            inactiveThumbColor: widget.isEnabled
                ? Colors.white
                : Colors.grey.shade400,
            inactiveTrackColor: widget.isEnabled
                ? Colors.grey.shade500
                : Colors.grey,
          ),
        ],
      ),
    );
  }
}
