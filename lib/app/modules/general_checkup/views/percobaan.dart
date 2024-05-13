import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/data_endpoint/mekanik.dart';
import '../../../data/endpoint.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String selectedItem;
  TextEditingController textFieldController = TextEditingController();
  List<String> selectedItems = [];



  @override
  void initState() {
    super.initState();
    selectedItem = 'Pilih';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Demo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
      FutureBuilder<Mekanik>(
        future: API.MekanikID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final mechanics = snapshot.data!.dataMekanik ?? [];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DropdownButton<String>(
                value: selectedItems.isNotEmpty ? selectedItems.last : null,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedItem = newValue!; // Update the selectedItem with the new value
                    textFieldController.text = newValue; // Update the text field controller
                  });
                },
                items: mechanics.map<DropdownMenuItem<String>>((mechanic) {
                  return DropdownMenuItem<String>(
                    value: mechanic.nama ?? '',
                    child: Text(mechanic.nama ?? ''),
                  );
                }).toList(),
              ),
            ],
          );
        }
      },
    ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                selectedItems.add(selectedItem);
              });
            },
            child: Text('Tambah'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: selectedItems.length,
              itemBuilder: (context, index) {
                return buildTextFieldAndStartButton(selectedItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextFieldAndStartButton(String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Selected Item',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: item),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              // Logic to start
            },
            child: Text('Start'),
          ),
        ],
      ),
    );
  }
}
