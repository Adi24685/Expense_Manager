import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/MYHOME.dart';
import 'package:expense_manager/goals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


String? n1;
String? cat1;
String? time1;
String? rs1;
bool isLoad = false;

String? n2;
String? cat2;
String? time2;
String? rs2;



Color _currentTextColor = Colors.red; // Initial text color
  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange
  ]; // List of colors
  int _currentIndex = 0; // To track the current color index
  late Timer _timer;

List<Map<String, dynamic>> lastT = [];
class Myhome extends StatelessWidget{
  const Myhome({super.key});
  @override  
  Widget build(BuildContext context){
    return Home_Page();
  }
}
class Home_Page extends StatefulWidget {
  @override
  State createState() => _Home_Page();
}


dynamic amount_received =0;
dynamic amount_send =0;
List<Map<String, dynamic>> transactions=[];


  



class _Home_Page extends State<Home_Page> {
 List<Map<String, dynamic>> allTransactions = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchTransactions();
     _startTextColorChange();
    
  }

  
  int _selectedIndex = 0; // To track the selected tab

  // Method to handle navigation between tabs
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
   


   void fetchTransactions() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('transactions')
          .get(); // Fetch all documents from the 'transactions' collection

      if (querySnapshot.docs.isEmpty) {
        print('No documents found in the transactions collection.');
      }
      amount_received =0;
      amount_send=0;

      // Map Firestore documents to a list of transactions
       transactions = querySnapshot.docs.map((doc) {
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
      
      print('Fetched transactions: $transactions');

      setState(() {

       
        allTransactions = transactions;
        isLoad = true;
        // int a=0;
        // for(int j =0;j< allTransactions.length-1;j++){
        //   if(allTransactions[j]['receiver'] == Username || allTransactions[j]['sender'] == Username){
        //     lastT[a] = allTransactions[j];
        //   }
        // }
       



        print(allTransactions);
        
        
        for(int h = 0; h<transactions.length;h++){
            if(Username == transactions[h]['receiver']){
 

        amount_received += transactions[h]['amount'];

      }
      if(Username == transactions[h]['sender']){
        amount_send +=transactions[h]['amount'];

      }
        }
        
        isLoading = false; // Stop loading indicator
      });
    } catch (e) {
      print('Error fetching transactions: $e');
      setState(() {
        isLoading = false; // Stop loading indicator even on error
      });
    }
  }

 void _startTextColorChange() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _colors.length;
        _currentTextColor = _colors[_currentIndex];
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
       
        ),
        title:  Text(
          'Expense Manager',
          style: GoogleFonts.quicksand(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w900),
          
        ),
        
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Search action
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Notification action
            },
          ),
        ],
      ),
      body: isLoading
          ? Container(
  height: MediaQuery.of(context).size.height,
  width: MediaQuery.of(context).size.width,
  decoration: const BoxDecoration(
    color: Colors.black87,
    image: DecorationImage(
      image: AssetImage('assets/images/loadback.jpg'), // Replace with your image asset path
      fit: BoxFit.fill // Adjust how the image fits the container
    ),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const CircularProgressIndicator(color: Colors.white),
      Text(
        "Welcome $Username",
        style:GoogleFonts.quicksand(
          fontSize: 25,
          color: _currentTextColor,
          fontWeight: FontWeight.w900
          
        ),
      ),
       Text(
        "fetching Data...",
        style: GoogleFonts.quicksand(color: Colors.white),
      ),
    ],
  ),
)

      
       :SingleChildScrollView(
         child: Column(
           children: [
            
             Container(
              decoration: const BoxDecoration(
                
              ),
               child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30,),
                      // First show the card with balance
                     Container(
      width: MediaQuery.of(context).size.width*0.92,
      height: MediaQuery.of(context).size.width*0.5,
      decoration: BoxDecoration(
        color:  Colors.black87,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    Row(
                      children: [
                        const Icon(Icons.currency_rupee_sharp,color: Colors.white,size: 25,),
                        Text(
                          "${amount_received - amount_send}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(Username!,style: const TextStyle(color: Colors.white,fontSize: 15),),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "Balance",
                  style: GoogleFonts.quicksand(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            // Progress Bar
            Container(
              height: 5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(5),
              ),
              child: FractionallySizedBox(
                widthFactor: 0.6, // Adjust the fill percentage
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            // Card Number and Mastercard Logo
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Masked Card Number
                Row(
                  children: [
                    Text(
                      "* * **",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "402",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                // Mastercard Logo
                Row(
                  children: [
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.red,
                    ),
                    SizedBox(width: 5),
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
                     // Then display the row for Income and Expense
                      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.arrow_downward, color: Colors.green, size: 28),
                       const  SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           const  Icon(Icons.currency_rupee_sharp,color: Colors.green,size: 20,),
                            Text(
                              '$amount_received',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                       Text(
                          'Income',
                          style: GoogleFonts.quicksand(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding:const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow:const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.arrow_upward, color: Colors.orange, size: 28),
                       const  SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           const  Icon(Icons.currency_rupee_sharp,color: Colors.orange,size: 20,),
                            Text(
                              '$amount_send',
                              style:const  TextStyle(
                                color: Colors.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                         Text(
                          'Expense',
                          style: GoogleFonts.quicksand(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
             const  SizedBox(height: 20),
              // Transactions Header
               Text(
                'Recent Transations',
                style: GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Transaction Card 1
              Container(
  margin: const EdgeInsets.symmetric(vertical: 8.0),
  padding:const  EdgeInsets.all(16.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow:const  [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
             transactions[transactions.length - 1]['receiver']==Username ?

             ( transactions[transactions.length - 1]['sender']==null?'wait':
            '${transactions[transactions.length - 1]['sender']}'):

           ( transactions[transactions.length - 1]['receiver']==null?'wait':
            '${transactions[transactions.length - 1]['receiver']}'),
            style:const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4), // Space between receiver and category
          Text(
             transactions[transactions.length - 1]['category']==null?'wait':
            '${transactions[transactions.length - 1]['category']}',
            style:const  TextStyle(
              fontSize: 14,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        const  SizedBox(height: 4), // Space between category and timestamp
          Text(
            ( transactions[transactions.length - 1]['timestamp']==null?'wait':
            '${transactions[transactions.length - 1]['timestamp']}'),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      Text(
        ( transactions[transactions.length - 1]['amount']==null?'wait':
            '${transactions[transactions.length - 1]['amount']}'),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    ],
  ),
),

              // Transaction Card 2
              Container(
  margin: const EdgeInsets.symmetric(vertical: 8.0),
  padding: const EdgeInsets.all(16.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow:const  [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
             transactions[transactions.length - 1]['receiver']==Username ?

             ( transactions[transactions.length - 1]['sender']==null?'wait':
            '${transactions[transactions.length - 1]['sender']}'):

           ( transactions[transactions.length - 2]['receiver']==null?'wait':
            '${transactions[transactions.length - 2]['receiver']}'),
            style:const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
         const  SizedBox(height: 4), // Space between receiver and category
          Text(
             transactions[transactions.length - 2]['category']==null?'wait':
            '${transactions[transactions.length - 2]['category']}',
            style:const  TextStyle(
              fontSize: 14,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4), // Space between category and timestamp
          Text(
            ( transactions[transactions.length - 2]['timestamp']==null?'wait':
            '${transactions[transactions.length - 2]['timestamp']}'),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
      Text(
        ( transactions[transactions.length - 2]['amount']==null?'wait':
            '${transactions[transactions.length - 2]['amount']}'),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    ],
  ),
),
            ],
          ),
               ),
               Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       // My Savings Container
                       Container(
                  width: 100, // Adjust width as necessary
                  padding:const  EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[100], // Sky blue background
                    border: Border.all(color: Colors.blue[900]!, width: 2), // Dark blue border
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.savings, color: Colors.purple, size: 30), // Icon for savings
                      const SizedBox(height: 8),
                      Text(
                        'Savings',
                        style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                       ),


                       
                       
                      // Goals Container
               GestureDetector(
                 onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) {
                     return ExpenseGoals();
                   }));
                 },
                 child: Container(
                   width: 100, // Adjust width as necessary
                   padding: const EdgeInsets.all(12.0),
                   decoration: BoxDecoration(
                     color: Colors.lightBlue[100], // Sky blue background
                     border: Border.all(color: Colors.blue[900]!, width: 2), // Dark blue border
                     borderRadius: BorderRadius.circular(10),
                   ),
                   child:  Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
               const  Icon(Icons.flag, color: Colors.blue, size: 30), // Icon for goals
                const SizedBox(height: 8),
                Text(
                  'Goals',
                  style: GoogleFonts.quicksand(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                     ],
                   ),
                 ),
               ),
               
                 
                       // Notes Container
                       Container(
                  width: 100, // Adjust width as necessary
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[100], // Sky blue background
                    border: Border.all(color: Colors.blue[900]!, width: 2), // Dark blue border
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.note, color: Colors.purple, size: 30), // Icon for notes
                     const  SizedBox(height: 8),
                      Text(
                        'Notes',
                        style: GoogleFonts.quicksand(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                       ),
                     ],
                   ),
                      // Financial Stability Image Section
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow:const  [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8.0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                           
                            
                          ),
                        ),
                      ),
                   const  SizedBox(height: 50,)],
                  ),
                  
                       ),
             ),
           ],
         ),
       ),
       
     
    );
  }
}