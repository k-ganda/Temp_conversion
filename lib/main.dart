import 'package:flutter/material.dart';

void main() {
  runApp(const TempApp());
}

class TempApp extends StatefulWidget {
  const TempApp({super.key});

  @override
  State<TempApp> createState() => _TempAppState();
}

// Use enumeration to allow defining set of values in this case 2 possible values.
enum ConversionType {
  CelsiusToFahrenheit,
  FahrenheitToCelsius,
}

class _TempAppState extends State<TempApp> {
  double temperature = 0.0;
  String input = "";
  ConversionType conversionType = ConversionType.CelsiusToFahrenheit;
  List<String> history = [];
  final TextEditingController _controller = TextEditingController();

  void convertTemperature() {
    setState(() {
      double convertedTemperature;
      //If the conversion type is Celsius to Fahrenheit, convert temperature to Fahrenheit then add to history(2 decimal places)
      if (conversionType == ConversionType.CelsiusToFahrenheit) {
        convertedTemperature = temperature * 9 / 5 + 32;
        history.insert(0,
            'C to F: ${temperature.toStringAsFixed(2)}°C = ${convertedTemperature.toStringAsFixed(2)}°F');
        //If the conversion type is Farheneit to Celsius, convert temperature to Celsius then add to history(2 decimal places)
      } else {
        convertedTemperature = (temperature - 32) * 5 / 9;
        history.insert(0,
            'F to C: ${temperature.toStringAsFixed(2)}°F = ${convertedTemperature.toStringAsFixed(2)}°C');
      }
      temperature = convertedTemperature;
      input =
          ""; // Clear input after conversion to allow user to enter a new value in the text field
      _controller.clear(); // Clear the text field
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Temperature Conversion App",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Dropdown with the conversion types
                  DropdownButton<ConversionType>(
                    value: conversionType,
                    onChanged: (ConversionType? newValue) {
                      setState(() {
                        conversionType = newValue!;
                      });
                    },
                    items: ConversionType.values.map((ConversionType value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                  TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    onChanged: (String newValue) {
                      setState(() {
                        temperature = double.tryParse(newValue) ?? 0.0;
                      });
                    },
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Enter temperature",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: convertTemperature,
                    child: const Text('Convert'),
                  ),
                  Text(
                    '${conversionType == ConversionType.CelsiusToFahrenheit ? '°F' : '°C'}: ${temperature.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(history[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
