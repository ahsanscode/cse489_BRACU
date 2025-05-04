import 'package:flutter/material.dart';

void main() {
  runApp(VangtiChaiApp());
}

class VangtiChaiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: VangtiChaiHomePage(),
    );
  }
}

class VangtiChaiHomePage extends StatefulWidget {
  @override
  _VangtiChaiHomePageState createState() => _VangtiChaiHomePageState();
}

class _VangtiChaiHomePageState extends State<VangtiChaiHomePage> {
  // Stores the entered amount as a string.
  String amountStr = "";

  // List of Taka denominations.
  final List<int> denominations = [500, 100, 50, 20, 10, 5, 2, 1];

  // Compute change: for each note, calculate how many notes are needed.
  Map<int, int> computeChange(int amount) {
    Map<int, int> change = {};
    for (int note in denominations) {
      int count = amount ~/ note;
      change[note] = count;
      amount %= note;
    }
    return change;
  }

  // Append a digit when a numeric button is pressed.
  void onDigitPressed(String digit) {
    setState(() {
      if (amountStr == "0") {
        amountStr = digit;
      } else {
        amountStr += digit;
      }
    });
  }

  // Clear the entered amount.
  void onClearPressed() {
    setState(() {
      amountStr = "";
    });
  }

  // Build a numeric keypad that adapts to available size.
  Widget buildKeypad(BoxConstraints constraints) {
    // We know the grid is 3 columns.
    int columns = 3;
    // There are 4 rows (digits 1-9, clear, 0, and a spacer).
    int rows = 4;
    // Calculate the approximate width and height for each cell.
    double cellWidth = (constraints.maxWidth - 16) / columns; // subtracting padding
    double cellHeight = (constraints.maxHeight - 16) / rows;
    double aspectRatio = cellWidth / cellHeight;

    return GridView.count(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: columns,
      childAspectRatio: aspectRatio,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: [
        // Buttons 1-9.
        ...List.generate(9, (index) {
          return ElevatedButton(
            onPressed: () => onDigitPressed('${index + 1}'),
            child: Text('${index + 1}', style: TextStyle(fontSize: 20)),
          );
        }),
        // Clear button.
        ElevatedButton(
          onPressed: onClearPressed,
          child: Text('Clear', style: TextStyle(fontSize: 20)),
        ),
        // 0 button.
        ElevatedButton(
          onPressed: () => onDigitPressed('0'),
          child: Text('0', style: TextStyle(fontSize: 20)),
        ),
        // Empty placeholder.
        Container(),
      ],
    );
  }

  // Build keypad for portrait mode, using a fixed aspect ratio.
  Widget buildPortraitKeypad() {
    return GridView.count(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 3,
      childAspectRatio: 2.0,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: [
        ...List.generate(9, (index) {
          return ElevatedButton(
            onPressed: () => onDigitPressed('${index + 1}'),
            child: Text('${index + 1}', style: TextStyle(fontSize: 20)),
          );
        }),
        ElevatedButton(
          onPressed: onClearPressed,
          child: Text('Clear', style: TextStyle(fontSize: 20)),
        ),
        ElevatedButton(
          onPressed: () => onDigitPressed('0'),
          child: Text('0', style: TextStyle(fontSize: 20)),
        ),
        Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int amount = int.tryParse(amountStr) ?? 0;
    Map<int, int> change = computeChange(amount);
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    // Widget to display the current amount.
    Widget amountDisplay = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        "Taka: ${amountStr.isEmpty ? '0' : amountStr}",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );

    // Widget to display the change table.
    Widget changeTable = Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: denominations.map((note) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                "$note Taka: ${change[note]}",
                style: TextStyle(fontSize: 18),
              ),
            );
          }).toList(),
        ),
      ),
    );

    if (isPortrait) {
      // Portrait layout: amount display at the top, then a row with change table on left and keypad on right.
      return Scaffold(
        appBar: AppBar(title: Text('VangtiChai')),
        body: Column(
          children: [
            amountDisplay,
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    flex: 1,
                    child: changeTable,
                  ),
                  Flexible(
                    flex: 2,
                    child: buildPortraitKeypad(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Landscape layout: change table on the left; on the right, amount display at top and adaptive keypad below.
      return Scaffold(
        appBar: AppBar(title: Text('VangtiChai')),
        body: Row(
          children: [
            Flexible(
              flex: 1,
              child: changeTable,
            ),
            Flexible(
              flex: 2,
              child: Column(
                children: [
                  amountDisplay,
                  // Use LayoutBuilder to adapt the keypad grid based on available space.
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return buildKeypad(constraints);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
