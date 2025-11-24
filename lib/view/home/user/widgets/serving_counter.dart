import 'package:flutter/material.dart';

class ServingCounter extends StatefulWidget {
  const ServingCounter({super.key});

  @override
  State<ServingCounter> createState() => _ServingCounterState();
}

class _ServingCounterState extends State<ServingCounter> {
  late FixedExtentScrollController _controller;
  int selected = 1;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: selected);
  }

  void increment() {
    if (selected < 10) {
      selected++;
      _controller.animateToItem(
        selected,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
      setState(() {});
    }
  }

  void decrement() {
    if (selected > 0) {
      selected--;
      _controller.animateToItem(
        selected,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 240,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: decrement,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "-",
                style: TextStyle(fontSize: 32, color: Colors.white70),
              ),
            ),
          ),

          SizedBox(
            height: 100,
            width: 100,
            child: ListWheelScrollView.useDelegate(
              controller: _controller,
              physics: const FixedExtentScrollPhysics(),
              itemExtent: 50,
              onSelectedItemChanged: (index) {
                selected = index;
                setState(() {});
              },
              perspective: 0.003,
              diameterRatio: 1.2,
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  if (index < 0 || index > 10) return null;

                  final isSelected = index == selected;

                  return Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: isSelected ? 32 : 26,
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.2),
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
              padding: EdgeInsets.all(12.0),
              child: Text(
                "+",
                style: TextStyle(fontSize: 32, color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
