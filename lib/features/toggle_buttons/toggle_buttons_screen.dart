import 'package:flutter/material.dart';
import 'package:flutter_feature_all_in_one/view_source_code.dart';

class ToggleButtonsScreen extends StatefulWidget {
  const ToggleButtonsScreen({super.key});

  @override
  State<ToggleButtonsScreen> createState() => _ToggleButtonsScreenState();
}

class _ToggleButtonsScreenState extends State<ToggleButtonsScreen> {
  bool isAllow = true;
  bool isDenied = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Toggle Buttons"),
        actions: [
          ElevatedButton(
            onPressed: () {
              String filePath =
                  'lib/features/toggle_buttons/toggle_buttons_screen.dart';
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SourceCodeView(filePath: filePath),
                ),
              );
            },
            child: Text('Source Code'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_singleToggleButton(), _multiSelectButton()],
        ),
      ),
    );
  }

  _singleToggleButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Single Toggle Button",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buttonWidget(
                title: "Allow",
                isSelected: isAllow,
                onTap: () {
                  isAllow = true;
                  isDenied = false;
                  setState(() {});
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buttonWidget(
                title: "Deny",
                isSelected: isDenied,
                onTap: () {
                  isAllow = false;
                  isDenied = true;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  List<String> selectedDays = [];
  _multiSelectButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Multiple Select Button",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        _buttonWidget(
          title: 'Select All',
          isSelected: days.length == selectedDays.length,
          onTap: () {
            if (days.length == selectedDays.length) {
              selectedDays = [];
            } else {
              selectedDays = days;
            }
            setState(() {});
          },
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(days.length, (index) {
            return _buttonWidget(
              title: days[index],
              isSelected: selectedDays.contains(days[index]),
              onTap: () {
                if (selectedDays.contains(days[index])) {
                  selectedDays.remove(days[index]);
                } else {
                  selectedDays.add(days[index]);
                }
                setState(() {});
              },
            );
          }),
        ),
      ],
    );
  }

  _buttonWidget({title, isSelected, void Function()? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.white,
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.redAccent : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
