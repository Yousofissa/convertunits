import 'package:flutter/material.dart';

void main() {
  runApp(const UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const ConverterPage(),
    );
  }
}

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  String category = "Length";
  String fromUnit = "Meter";
  String toUnit = "Kilometer";

  String resultText = "";
  String errorMessage = "";

  final TextEditingController valueController = TextEditingController();

  final List<String> lengthUnits = ["Meter", "Kilometer", "Centimeter"];
  final List<String> weightUnits = ["Kilogram", "Gram"];
  final List<String> tempUnits = ["Celsius", "Fahrenheit", "Kelvin"];

  List<String> getUnitsForCategory(String cat) {
    if (cat == "Length") {
      return lengthUnits;
    }
    if (cat == "Weight") {
      return weightUnits;
    }
    return tempUnits;
  }

  void onCategoryChanged(String newCategory) {
    List<String> units = getUnitsForCategory(newCategory);

    setState(() {
      category = newCategory;
      fromUnit = units.first;
      toUnit = units.length > 1 ? units[1] : units.first;
      valueController.clear();
      errorMessage = "";
      resultText = "";
    });
  }

  void convert() {
    setState(() {
      errorMessage = "";
      resultText = "";
    });

    if (valueController.text.trim().isEmpty) {
      setState(() {
        errorMessage = "Please enter a value to convert.";
      });
      return;
    }

    double? value = double.tryParse(valueController.text);
    if (value == null) {
      setState(() {
        errorMessage = "Invalid input. Enter a number.";
      });
      return;
    }

    double converted = value;


    if (category == "Length") {
      if (fromUnit == "Meter" && toUnit == "Kilometer") {
        converted = value / 1000;
      } else if (fromUnit == "Kilometer" && toUnit == "Meter") {
        converted = value * 1000;
      } else if (fromUnit == "Meter" && toUnit == "Centimeter") {
        converted = value * 100;
      } else if (fromUnit == "Centimeter" && toUnit == "Meter") {
        converted = value / 100;
      } else if (fromUnit == "Kilometer" && toUnit == "Centimeter") {
        converted = value * 100000;
      } else if (fromUnit == "Centimeter" && toUnit == "Kilometer") {
        converted = value / 100000;
      }
    }


    else if (category == "Weight") {
      if (fromUnit == "Kilogram" && toUnit == "Gram") {
        converted = value * 1000;
      } else if (fromUnit == "Gram" && toUnit == "Kilogram") {
        converted = value / 1000;
      }
    }


    else if (category == "Temperature") {
      if (fromUnit == "Celsius" && toUnit == "Fahrenheit") {
        converted = (value * 9 / 5) + 32;
      } else if (fromUnit == "Fahrenheit" && toUnit == "Celsius") {
        converted = (value - 32) * 5 / 9;
      } else if (fromUnit == "Celsius" && toUnit == "Kelvin") {
        converted = value + 273.15;
      } else if (fromUnit == "Kelvin" && toUnit == "Celsius") {
        converted = value - 273.15;
      }
    }

    setState(() {
      resultText = "$value $fromUnit = ${converted.toStringAsFixed(4)} $toUnit";
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> currentUnits = getUnitsForCategory(category);


    if (!currentUnits.contains(fromUnit)) {
      fromUnit = currentUnits.first;
    }
    if (!currentUnits.contains(toUnit)) {
      toUnit = currentUnits.length > 1 ? currentUnits[1] : currentUnits.first;
    }

    return Container(
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.lightBlue.shade100, Colors.lightBlue.shade200],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            "Unit Converter",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Category",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(child: buildCategoryButton("Length")),
                  const SizedBox(width: 8),
                  Expanded(child: buildCategoryButton("Weight")),
                  const SizedBox(width: 8),
                  Expanded(child: buildCategoryButton("Temperature")),
                ],
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Value",
                        style: TextStyle(
                            fontSize: 16, color: Colors.blueAccent)),
                    const SizedBox(height: 8),

                    TextField(
                      controller: valueController,
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter a number",
                      ),
                    ),

                    const SizedBox(height: 20),

                    buildDropdown("From unit", currentUnits, fromUnit,
                            (v) => setState(() => fromUnit = v!)),

                    const SizedBox(height: 16),

                    buildDropdown("To unit", currentUnits, toUnit,
                            (v) => setState(() => toUnit = v!)),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: convert,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          "Convert",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (errorMessage.isNotEmpty)
                      Text(
                        errorMessage,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),

                    if (resultText.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          resultText,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildCategoryButton(String text) {
    bool selected = (category == text);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.blueAccent : Colors.white,
        foregroundColor: selected ? Colors.white : Colors.black,
        side: BorderSide(
          color: selected ? Colors.blueAccent : Colors.grey.shade300,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: () => onCategoryChanged(text),
      child: Text(text),
    );
  }


  Widget buildDropdown(String label, List<String> items, String value,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items
              .map(
                (u) => DropdownMenuItem(
              value: u,
              child: Text(u),
            ),
          )
              .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}
