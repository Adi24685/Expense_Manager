import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/MYHOME.dart';
import 'package:expense_manager/send.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
String? touser;
class PaymentScreen extends StatefulWidget {
  final String username;
   PaymentScreen(this.username, {Key? key}) : super(key: key){
    touser=username;
   }

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();

     WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }
  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // Alternatively, you can use animateTo for smooth scrolling:
    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: Duration(milliseconds: 300),
    //   curve: Curves.easeInOut,
    // );
  }

  void fetchTransactions() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('transactions').get();

      if (querySnapshot.docs.isEmpty) {
        print('No documents found in the transactions collection.');
      }

      List<Map<String, dynamic>> fetchedTransactions = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'sender': data['sender'] ?? 'Unknown Sender',
          'receiver': data['receiver'] ?? 'Unknown Receiver',
          'amount': int.tryParse(data['amount'].toString()) ?? 0,
          'timestamp': data['timestamp'] != null
              ? (data['timestamp'] as Timestamp).toDate()
              : DateTime.now(),
          'category': data['category'] ?? 'General',
        };
      }).toList();

      // Filter transactions where username matches sender or receiver
      setState(() {
        transactions = fetchedTransactions.where((transaction) {
          return ((transaction['sender'] == Username &&
              transaction['receiver'] == touser) || (transaction['receiver'] == Username && transaction['sender'] == touser));
        }).toList();
      });

      print('Filtered transactions: $transactions');
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor:Colors.grey[800],
        
        title: Text(
  '${widget.username[0].toUpperCase()}${widget.username.substring(1).toLowerCase()}',
  style: GoogleFonts.quicksand(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  ),
),

        actions: const [
          Icon(Icons.access_time_rounded, color: Colors.red),
          SizedBox(width: 10),
          Icon(Icons.help_outline, color: Colors.red),
          SizedBox(width: 10),
          Icon(Icons.more_vert, color: Colors.red),
          SizedBox(width: 10),
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back,color: Colors.white,size: 25,)),
      ),
      body: transactions.isEmpty
          ? Center(
              child: Text(
                "No transactions found",
                style: GoogleFonts.quicksand(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
             controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final bool isReceived =
                    transaction['receiver'] == widget.username;
                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: isReceived
                        ? Colors.black54
                        : Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹${transaction['amount']}',
                        style: GoogleFonts.quicksand(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isReceived ? Colors.red : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: isReceived ? Colors.red : Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            isReceived
                                ? 'Sent Securely'
                                : 'Received Instantly',
                            style: GoogleFonts.quicksand(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isReceived ? Colors.red : Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        transaction['timestamp'].toString(),
                        style: GoogleFonts.quicksand(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
  padding: const EdgeInsets.all(16.0),
  child: GestureDetector(
    onTap: () {
      // Navigate to the desired page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>Send(touser!)), // Replace with your desired page
      );
    },
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          "Pay Again",
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ),
),

    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
