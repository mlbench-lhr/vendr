import 'package:flutter/material.dart';

class ServingCounter extends StatefulWidget {
  const ServingCounter({
    super.key,
    required this.onServingChanged,
    required this.servingsLength,
  });
  final ValueChanged<int> onServingChanged;
  final int servingsLength;
  @override
  State<ServingCounter> createState() => _ServingCounterState();
}

class _ServingCounterState extends State<ServingCounter> {
  final List<int> units = [1, 2, 5, 10];

  late FixedExtentScrollController _controller;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: selectedIndex);
  }

  void increment() {
    if (selectedIndex < widget.servingsLength - 1) {
      selectedIndex++;
      _controller.animateToItem(
        selectedIndex,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
      setState(() {
        widget.onServingChanged(selectedIndex);
      });
    }
  }

  void decrement() {
    if (selectedIndex > 0) {
      selectedIndex--;
      _controller.animateToItem(
        selectedIndex,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
      setState(() {
        widget.onServingChanged(selectedIndex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min, // ⭐ IMPORTANT
        children: [
          GestureDetector(
            onTap: decrement,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "-",
                style: TextStyle(fontSize: 34, color: Colors.white70),
              ),
            ),
          ),

          SizedBox(
            height: 90, // reduced
            child: ListWheelScrollView.useDelegate(
              controller: _controller,
              physics: const FixedExtentScrollPhysics(),
              itemExtent: 40, // reduced
              onSelectedItemChanged: (index) {
                selectedIndex = index;
                setState(() {});
              },
              perspective: 0.003,
              diameterRatio: 1.3,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: widget.servingsLength,
                builder: (context, index) {
                  final isSelected = index == selectedIndex;

                  return Center(
                    child: Text(
                      "${units[index]}",
                      style: TextStyle(
                        fontSize: isSelected ? 26 : 20,
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          GestureDetector(
            onTap: increment,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "+",
                style: TextStyle(fontSize: 34, color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
