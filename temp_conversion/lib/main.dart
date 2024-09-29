import 'package:flutter/material.dart';

void main() {
  runApp(TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TemperatureConverterScreen(),
    );
  }
}

class TemperatureConverterScreen extends StatefulWidget {
  @override
  _TemperatureConverterScreenState createState() =>
      _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState
    extends State<TemperatureConverterScreen> {
  final TextEditingController _controller = TextEditingController();
  double _result = 0.0;
  String _selectedConverter = 'Celsius to Fahrenheit'; // Default selection
  final List<String> _converters = [
    'Celsius to Fahrenheit',
    'Fahrenheit to Celsius'
  ];

  // List to store history of conversions
  List<String> _conversionHistory = [];

  void _convertTemperature() {
    // Get the input from the TextField
    String input = _controller.text;

    // Try to parse the input as a double
    double? temperature = double.tryParse(input);

    if (temperature != null) {
      String historyEntry;
      setState(() {
        if (_selectedConverter == 'Celsius to Fahrenheit') {
          // Convert Celsius to Fahrenheit
          _result = (temperature * 9 / 5) + 32;
          historyEntry =
              'C to F: $temperature => ${_result.toStringAsFixed(1)}';
        } else {
          // Convert Fahrenheit to Celsius
          _result = (temperature - 32) * 5 / 9;
          historyEntry =
              'F to C: $temperature => ${_result.toStringAsFixed(1)}';
        }

        // Add the conversion to history
        _conversionHistory.add(historyEntry);
      });
    } else {
      // If the input is invalid, set _result to 0
      setState(() {
        _result = 0.0;
      });
    }
  }

  // Method to show history in a dialog
  void _showHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conversion History'),
          content: SizedBox(
            height: 200,
            width: 300,
            child: ListView.builder(
              itemCount: _conversionHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_conversionHistory[index]),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Converter'),
        actions: [
          // Button to open the history dialog
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _showHistory,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dropdown for selecting conversion type
            DropdownButton<String>(
              value: _selectedConverter,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedConverter = newValue!;
                });
              },
              items: _converters.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Temperature',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertTemperature,
              child: Text('Convert'),
            ),
            SizedBox(height: 20),
            Text(
              'Result: $_result',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
