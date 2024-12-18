import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/MYHOME.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts package
import 'database.dart';

final usernameController = TextEditingController();
final amountController = TextEditingController();
List<Map<String, dynamic>> transactions = [];

class Send extends StatefulWidget {
  Send(String touser) {
    usernameController.text = touser;
  }
  @override
  _SendState createState() => _SendState();
}

class _SendState extends State<Send> {
  String categoryValue = 'Category';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text(
          'Expense Manager',
          style: GoogleFonts.quicksand(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child:const  Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.grey[800],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name :',
                style: GoogleFonts.quicksand(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Amount :',
                style: GoogleFonts.quicksand(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: amountController,
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.black,
                iconEnabledColor: Colors.white,
                value: categoryValue,
                onChanged: (String? newValue) {
                  setState(() {
                    categoryValue = newValue!;
                  });
                },
                items: <String>['Category', 'Food', 'Bills', 'Entertainment']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.quicksand(
                        color: value == categoryValue
                            ? Colors.red
                            : Colors.white,
                      ),
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  labelText: 'Category',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String receiver = usernameController.text.trim();
                    double amount =
                        double.tryParse(amountController.text) ?? 0.0;
                    String category = categoryValue;

                    if (receiver.isEmpty ||
                        amount <= 0 ||
                        category == 'Category') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please provide valid inputs.'),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }

                    try {
                      String transactionId =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      FirebaseFirestore.instance
                          .collection('transactions')
                          .doc(transactionId)
                          .set({
                        'sender': "$Username",
                        'receiver': usernameController.text,
                        'amount': amountController.text,
                        'category': categoryValue,
                        'timestamp': FieldValue.serverTimestamp()
                      }).then((value) => print('Transaction added'))
                          .catchError((error) => print(
                              'Failed to add transaction: $error'));
                      await sendData(receiver, amount, category);
                      Navigator.pop(context, true);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Transaction saved successfully!'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Failed to save transaction: $e'),
                        backgroundColor: Colors.red,
                      ));
                    }
                    setState(() {
                      usernameController.clear();
                      amountController.clear();
                      categoryValue = 'Category';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 15),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
