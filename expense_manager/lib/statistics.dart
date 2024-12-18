import 'package:expense_manager/FL_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'database.dart';


Map<String, Color> predefinedCategoryColors = {
  'Entertainment': Colors.greenAccent,
  'Food': Colors.yellow,
  'Bills': Colors.blueAccent,
};
 


Map<String, Color> categoryColors = {};

class FinancialReportPage extends StatefulWidget {
  @override
  _FinancialReportPageState createState() => _FinancialReportPageState();
}

class _FinancialReportPageState extends State<FinancialReportPage> {
  String selectedPeriod = 'Month';
  List<Map<String, dynamic>> categoryWiseExpenses = [];
  double totalExpenses = 0.0;
  Map<String, double> dataMap = {};

  @override
  void initState() {
    super.initState();
    loadCategoryWiseExpenses();
  }

  List<Color> generateBlendedColors(List<Color> baseColors, int count) {
    List<Color> blendedColors = [];
    for (int i = 0; i < count; i++) {
      final color = Color.lerp(
        baseColors[i % baseColors.length],
        baseColors[(i + 1) % baseColors.length],
        0.5,
      )!;
      blendedColors.add(color);
    }
    return blendedColors;
  }

  Future<void> loadCategoryWiseExpenses() async {
    final data = await fetchCategoryWiseExpenses();
    setState(() {
      categoryWiseExpenses = data;
      totalExpenses = categoryWiseExpenses.fold(
        0.0,
        (sum, item) => sum + (item['totalAmount'] as double),
      );
      assignColorsToCategories();
      updateDataMap();
    });
  }

  void assignColorsToCategories() {
    for (var expense in categoryWiseExpenses) {
      final category = expense['category'] as String;
      if (!categoryColors.containsKey(category)) {
        categoryColors[category] = predefinedCategoryColors[category] ??
            Colors.grey;
      }
    }
  }

  void updateDataMap() {
    dataMap = {
      for (var expense in categoryWiseExpenses)
        expense['category'] as String: expense['totalAmount'] as double,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1939),
      body: Column(
        children: [
          // Top Section: Balance & Spent Today
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      
                      ElevatedButton(onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return BarChartScreen();
                        }));
                      }, child:  Row(
                        children: [
                          const Icon(Icons.calendar_month,color: Colors.black,),
                          Text("weekly report",style:GoogleFonts.quicksand(color: Colors.black,fontSize: 10,fontWeight: FontWeight.w900,),),
                        ],
                      ))
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                 Text(
                  'Statistics',
                  style: GoogleFonts.quicksand(fontSize: 30, color: Colors.white),

                ),
                
                //const SizedBox(height: 8),
              
                const SizedBox(height: 8),
               // const SizedBox(height: 20),
                Center(
                  child: dataMap.isNotEmpty
                      ? PieChart(
                        legendOptions: const LegendOptions(
                          showLegends: true,
                          legendPosition: LegendPosition.bottom,
                          legendTextStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                          dataMap: dataMap,
                          colorList: categoryColors.values.toList(),
                          chartType: ChartType.ring,
      
                          animationDuration:
                              const Duration(milliseconds: 800),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValues: false,
                          ),
                          centerText: "Rs ${totalExpenses.toStringAsFixed(2)}\nSpent ",
                          chartRadius:
                              MediaQuery.of(context).size.width / 2.8,
                              
                              
                        )
                      :  Text(
                          'No data to display',
                          style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                ),
              ],
            ),
          ),

          // Bottom Section: Transaction List
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [ Colors.black87,Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
              
               child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryWiseExpenses.length,
                itemBuilder: (context, index) {
                  final expense = categoryWiseExpenses[index];
                  final category = expense['category'];
                  final amount = expense['totalAmount'] as double;
                  final color = categoryColors[category]!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              category[0], // First letter of the category
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rs ${amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

        ],
      ),

      
    );
  }
}

Future<List<Map<String, dynamic>>> fetchCategoryWiseExpenses() async {
  final db = await initializeDatabase();
  final result = await db.rawQuery('''
    SELECT category, SUM(amount) as totalAmount 
    FROM transactions 
    GROUP BY category
  ''');
  return result;
}