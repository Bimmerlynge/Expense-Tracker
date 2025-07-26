import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../network/mock/mock_dio_setup.dart';

class AddEntryForm extends StatefulWidget {
  const AddEntryForm({super.key});

  @override
  State<AddEntryForm> createState() => _AddEntryFormState();
}

class _AddEntryFormState extends State<AddEntryForm> {
  final List<String> persons = [
    'Mathias', 'Freja'
  ];

  String _response = '';

  Future sendRequest() async {
    try {
      final response = await dio.get('https://api.dataforsyningen.dk/vejnavne');
      setState(() {
        _response = response.data.toString();
      });
      print("resposne: $_response");
    } on DioException catch (e) {
      print('${e.response!.statusCode}: ${e.response!.data}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const TextField(
            decoration: InputDecoration(
              label: Text("Amount")
            ),
          ),
          DropdownButtonFormField(
            items: persons.map((p) {
              return DropdownMenuItem(value: p, child: Text(p));
            }).toList(),

            onChanged: (value) {  },
          ),


          ElevatedButton(onPressed: sendRequest, child: const Text("Send")),
          const SizedBox(height: 20),
          Text(_response),
        ],
      ),
    );
  }
}
