import 'package:expense_manager/PersonalPay.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database.dart';
import 'send.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    List<Map<String, dynamic>> receivedTransactions =
        await _fetchTransactionsFORChat();

    setState(() {
      _transactions = receivedTransactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text(
          "Send Money",
          style: GoogleFonts.quicksand(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: _fetchTransactions,
            icon: const Icon(
              Icons.refresh,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () {}, // Add help functionality here if needed
            icon: const Icon(
              Icons.help_outline,
              color: Colors.red,
            ),
          ),
        ],
        backgroundColor: Colors.grey[800],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[800],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: GoogleFonts.quicksand(color: Colors.white),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.quicksand(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _transactions.isEmpty
                    ? Center(
                        child: Text(
                          "No transactions found",
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = _transactions[index];
                          return transactionItem(
                            transaction['receiver'] ?? 'Unknown',
                            transaction['amount'].toString(),
                            transaction['timestamp'] ?? 'No Date',
                          );
                        },
                      ),
              ),
            ],
          ),
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Send('')),
                );
                if (result == true) {
                  _fetchTransactions();
                }
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionItem(String name, String amount, String date) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return PaymentScreen(name);
                },
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white, // Bottom border color
                        width: 1.0, // Bottom border width
                      ),
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Text('₹$amount', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.quicksand(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const Row(
          children: [
            SizedBox(width: 50), // Add 20px space before the divider starts
            Expanded(
              child: Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Future<List<Map<String, dynamic>>> _fetchTransactionsFORChat() async {
  List<Map<String, dynamic>> receivedTransactions = await fetchTransactions();

  // Filter to only keep the latest transaction for each unique receiver
  Map<String, Map<String, dynamic>> uniqueTransactions = {};
  for (var transaction in receivedTransactions) {
    final receiver = transaction['receiver'] ?? 'Unknown';
    final timestamp = transaction['timestamp'] ?? '';

    if (uniqueTransactions.containsKey(receiver)) {
      // Compare timestamps to keep the latest transaction
      if (DateTime.parse(timestamp)
          .isAfter(DateTime.parse(uniqueTransactions[receiver]!['timestamp']))) {
        uniqueTransactions[receiver] = transaction;
      }
    } else {
      uniqueTransactions[receiver] = transaction;
    }
  }

  // Return the filtered transactions as a list
  return uniqueTransactions.values.toList();
}
