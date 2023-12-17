import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BarcodeScanScreen(),
    );
  }
}

class BarcodeScanScreen extends StatefulWidget {
  @override
  _BarcodeScanScreenState createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
  String scannedBarcode = "Scan a barcode";

  Future<void> scanBarcode() async {
    try {
      String barcode = (await BarcodeScanner.scan()) as String;
      List<String> ingredients = await getIngredientsFromBarcode(barcode);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => IngredientsPage(ingredients)),
      );
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          scannedBarcode = 'Camera permission was denied';
        });
      } else {
        setState(() {
          scannedBarcode = 'Error: $e';
        });
      }
    } on FormatException {
      setState(() {
        scannedBarcode = 'User pressed the "back" button before scanning';
      });
    } catch (e) {
      setState(() {
        scannedBarcode = 'Error: $e';
      });
    }
  }

  Future<List<String>> getIngredientsFromBarcode(String barcode) async {
    // Replace this with your logic to fetch ingredients based on the barcode.
    // This is a hypothetical function and should be implemented according to your needs.
    // For example, you might make an API call to get ingredient information.
    return Future.delayed(const Duration(seconds: 2), () {
      return ['Ingredient 1', 'Ingredient 2', 'Ingredient 3'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barcode Scanner"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              scannedBarcode,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanBarcode,
              child: Text("Scan Barcode"),
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientsPage extends StatelessWidget {
  final List<String> ingredients;

  IngredientsPage(this.ingredients);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingredients'),
      ),
      body: ListView.builder(
        itemCount: ingredients.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(ingredients[index]),
          );
        },
      ),
    );
  }
}
