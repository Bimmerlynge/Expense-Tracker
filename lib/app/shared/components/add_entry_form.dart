import 'package:dio/dio.dart';
import 'package:expense_tracker/domain/category.dart';
import 'package:expense_tracker/domain/person.dart';
import 'package:expense_tracker/domain/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../network/mock/mock_dio_setup.dart';

class AddEntryForm extends StatefulWidget {
  final void Function(Transaction) onSubmit;

  const AddEntryForm({super.key, required this.onSubmit});

  @override
  State<AddEntryForm> createState() => _AddEntryFormState();
}

class _AddEntryFormState extends State<AddEntryForm> {
  final _formKey = GlobalKey<FormState>();

  late String _category;
  late double _amount;
  TransactionType _type = TransactionType.expense;
  late Person _person;
  List<Person> _persons = [
    Person(id: "7roAszxuATYOjRYYunZFB2Bi02y1", name: "Freja"),
    Person(id: "hAVigm8dcjMXPQqdJDFYYW3Zys83", name: "Mathias")
  ];


  @override
  void initState() {
    super.initState();
    setState(() {
      _person = getDefaultPerson();
    });
  }

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
    return AlertDialog(
      title: Text('Add transaction'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              onChanged: (val) => _amount = double.parse(val),
              validator: (val) => val == null || double.tryParse(val) == null ? 'Enter a valid amount' : null
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Category'),
              onChanged: (val) => _category = val,
              validator: (val) => val == null || val.isEmpty ? 'Required' : null ,
            ),
            DropdownButtonFormField<TransactionType>(
              value: _type,
              items: TransactionType.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.name)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _type = val);
              }),
            DropdownButtonFormField<Person>(
              value: _person,
              onChanged: (Person? newValue) {
                setState(() {
                  _person = newValue!;
                });
              },
              items: _persons.map((p) {
                return DropdownMenuItem<Person>(
                  value: p,
                  child: Text(p.name),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Select Person'),
            ),
          ],
        )
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel')
        ),
        ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onSubmit(Transaction(
                    user: _person,
                    amount: _amount,
                    category: Category(name: _category),
                    type: _type)
                );
              }
            },
            child: Text('Tilføj')
        )
      ],
    );
  }

  Person getDefaultPerson() {
    var loggedIn = FirebaseAuth.instance.currentUser!.uid;

    return _persons.firstWhere(
        (p) => p.id == loggedIn
    );
  }
}
