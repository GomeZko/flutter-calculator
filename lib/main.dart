import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.signInAnonymously();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<MyHomePage> {
  String userInput = '';
  String answer = '';

  final List<String> buttons = [
    'C','DEL','%','/',
    '7','8','9','x',
    '4','5','6','-',
    '1','2','3','+',
    'ANS','0','.','='
  ];

  void buttonTapped(String buttonText){
    setState(() {

      if(buttonText == 'C'){
        userInput = '';
        answer = '';
      }

      else if(buttonText == 'DEL'){
        if(userInput.isNotEmpty){
          userInput = userInput.substring(0,userInput.length-1);
        }
      }

      else if(buttonText == '='){
        calculateResult();
      }

      else if(buttonText == 'ANS'){
        userInput += answer;
      }

      else{
        userInput += buttonText;
      }

    });
  }

  void calculateResult(){

    String finalInput = userInput.replaceAll('x','*');

    try{

      Parser p = Parser();
      Expression exp = p.parse(finalInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      answer = eval.toString();

      _saveToHistory(userInput, answer);

    }catch(e){

      answer = 'Error';

    }

  }

  void _saveToHistory(String expression, String result) {
    final now = DateTime.now();
    final timestamp =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final calculation = '$expression = $result';
    HistoryDB.insert(calculation, timestamp);
  }

  bool isOperator(String x){
    return x == '%' ||
        x == '/' ||
        x == 'x' ||
        x == '-' ||
        x == '+' ||
        x == '=';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.blueGrey[900],

      appBar: AppBar(
        title: const Text("Calculator"),
        actions: [

          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'History',
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryPage(),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConverterScreen(),
                ),
              );
            },
          )

        ],
      ),

      body: Column(
        children: [

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  Text(
                    userInput,
                    style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white),
                  ),

                  const SizedBox(height:10),

                  Text(
                    answer,
                    style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),

                ],
              ),
            ),
          ),

          Expanded(
            flex:2,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:4,
              ),
              itemBuilder:(context,index){

                return MyButton(

                  buttonText: buttons[index],

                  color: isOperator(buttons[index])
                      ? Colors.orange
                      : Colors.blueGrey,

                  textColor: Colors.white,

                  onTap: (){
                    buttonTapped(buttons[index]);
                  },

                );

              },
            ),
          )

        ],
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final Color? color;
  final Color? textColor;
  final String buttonText;
  final VoidCallback onTap;

  const MyButton({
    super.key,
    this.color,
    this.textColor,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: color ?? Colors.blue,
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {

  final TextEditingController kmController = TextEditingController();

  String result = '';

  void convert(){

    double km = double.tryParse(kmController.text) ?? 0;

    double miles = km * 0.621371;

    setState(() {
      result = miles.toStringAsFixed(3);
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("KM → Miles Converter"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            TextField(
              controller: kmController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Kilometers",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height:20),

            ElevatedButton(
              onPressed: convert,
              child: const Text("Convert"),
            ),

            const SizedBox(height:20),

            Text(
              "$result miles",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height:20),

            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: const Text("Back to Calculator"),
            )

          ],
        ),
      ),
    );
  }
}