
import 'package:expense_manager/database.dart';
import 'package:expense_manager/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   
  await initializeDatabase(); // Initialize the database
  await Firebase.initializeApp(options:const FirebaseOptions(
    apiKey: "AIzaSyBIAeQ1r1fpN4RM3yr6ab9HCsNEbGDyKz0",
     appId: "1:138233364769:android:4ce28b368b2072bef33e60",
      messagingSenderId: "138233364769", 
      projectId: "expensemanager-2b290"));
  runApp(const MyApp());
  //printAllTransactions();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animated Notch Bottom Bar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   /// Controller to handle PageView and also handles initial page
//   final _pageController = PageController(initialPage: 0);

//   /// Controller to handle bottom nav bar and also handles initial page
//   final NotchBottomBarController _controller = NotchBottomBarController(index: 0);

//   int maxCount = 5;

//   @override
//   void dispose() {
//     _pageController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     /// widget list
//     final List<Widget> bottomBarPages = [
//        Myhome(
//         // controller: (_controller),
//        ),
//        FinancialReportPage(),
//        Chat(),
//       TransactionsPage(),
       
//        ProfileScreen(),
      
//     ];
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(10),
//         child: PageView(
//           controller: _pageController,
//           physics: const NeverScrollableScrollPhysics(),
//           children: List.generate(bottomBarPages.length, (index) => bottomBarPages[index]),
//         ),
//       ),
//       extendBody: true,
//       bottomNavigationBar: (bottomBarPages.length <= maxCount)
//           ? AnimatedNotchBottomBar(
//               /// Provide NotchBottomBarController
//               notchBottomBarController: _controller,
//               color: Colors.white,
//               showLabel: true,
//               textOverflow: TextOverflow.visible,
//               maxLine: 1,
//               shadowElevation: 5,
//               kBottomRadius: 28.0,

//               // notchShader: const SweepGradient(
//               //   startAngle: 0,
//               //   endAngle: pi / 2,
//               //   colors: [Colors.red, Colors.green, Colors.orange],
//               //   tileMode: TileMode.mirror,
//               // ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),
//               notchColor: Colors.black87,

//               /// restart app if you change removeMargins
//               removeMargins: false,
//               bottomBarWidth:MediaQuery.of(context).size.width,
//               showShadow: false,
//               durationInMilliSeconds: 300,

//               itemLabelStyle: const TextStyle(fontSize: 10),

//               elevation: 1,
//               bottomBarItems: const [
//                 BottomBarItem(
//                   inActiveItem: Icon(
//                     Icons.home_filled,
//                     color: Colors.blueGrey,
//                   ),
//                   activeItem: Icon(
//                     Icons.home_filled,
//                     color: Colors.blueAccent,
//                   ),
//                   itemLabel: 'Home',
//                 ),
//                 BottomBarItem(
//                   inActiveItem: Icon(Icons.star, color: Colors.blueGrey),
//                   activeItem: Icon(
//                     Icons.view_agenda_outlined,
//                     color: Colors.blueAccent,
//                   ),
//                   itemLabel: 'Statistics',
//                 ),
//                  BottomBarItem(
//                   inActiveItem: Icon(
//                     Icons.add,
//                     color: Colors.blueGrey,
//                   ),
//                   activeItem: Icon(
//                     Icons.add,
//                     color: Colors.pink,
//                   ),
//                   itemLabel: 'send',
//                 ),
//                 BottomBarItem(
//                   inActiveItem: Icon(
//                     Icons.settings,
//                     color: Colors.blueGrey,
//                   ),
//                   activeItem: Icon(
//                     Icons.settings,
//                     color: Colors.pink,
//                   ),
//                   itemLabel: 'Transaction',
//                 ),
//                 BottomBarItem(
//                   inActiveItem: Icon(
//                     Icons.person,
//                     color: Colors.blueGrey,
//                   ),
//                   activeItem: Icon(
//                     Icons.person,
//                     color: Colors.yellow,
//                   ),
//                   itemLabel: 'Profile',
//                 ),
//               ],
//               onTap: (index) {
                
//                 _pageController.jumpToPage(index);
//               },
//               kIconSize: 24.0,
//             )
//           : null,
//     );
//   }
// }



