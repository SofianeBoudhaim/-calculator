import 'package:calculator/dbConnect/connection.dart';
import "package:flutter/material.dart";
import 'package:sqflite/sqflite.dart';

import 'models/ingredient.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
// var to store
// onChanged callback
   late List<Ingredient> ingredients;
   late String ingredient;
   late String quantity;
   late String kcal;

  String lipides = "0";
  String glucides = "0";
  String text = "";

  double kcalTotal = 0;

  String proteines = "0";

  double lipidesTotal = 0;
  double glucidesTotal = 0;
  double proteinesTotal = 0;

  final TextEditingController _controllerIngredient = TextEditingController();
  final TextEditingController _controllerQuantite = TextEditingController();
  final TextEditingController _controllerKcal = TextEditingController();
  final TextEditingController _controllerLipides = TextEditingController();
  final TextEditingController _controllerGlucides = TextEditingController();
  final TextEditingController _controllerProteines = TextEditingController();

   @override
   void initState(){
     super.initState();
     refreshIngredients();
   }

   Future refreshIngredients() async {
     this.ingredients = await Connection.instance.readAllIngredients();
   }


   void _setText() {
     setState(() {
       String res = "";
       res = quantity + "g de " + ingredient + " : ";

       double r = double.parse(quantity) / 100 * double.parse(kcal);

       kcalTotal += r;
       text = text + res + r.toString() + "kcal" + "\n";

       lipidesTotal += double.parse(lipides) / 100 * double.parse(quantity);
       glucidesTotal += double.parse(glucides) / 100 * double.parse(quantity);
       proteinesTotal += double.parse(proteines) / 100 * double.parse(quantity);
       _viderAffichage();
     });
   }

  void _viderAffichage(){
    _controllerIngredient.clear();
    _controllerQuantite.clear();
    _controllerKcal.clear();
    _controllerLipides.clear();
    _controllerGlucides.clear();
    _controllerProteines.clear();
  }

  void _vider() {
    setState(() {
      text = "";
      kcalTotal = 0;
      lipidesTotal = 0;
      glucidesTotal = 0;
      proteinesTotal = 0;
      _viderAffichage();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculateur de calories'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: size.width * 0.2,
                    child: TextField(
                      controller: _controllerIngredient,
                      decoration:
                          const InputDecoration(labelText: 'Ingrédient : '),
                      onChanged: (value) => ingredient = value,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: size.width * 0.2,
                    child: TextField(
                      controller: _controllerQuantite,
                      decoration:
                          const InputDecoration(labelText: 'Quantité : '),
                      onChanged: (value) => quantity = value,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: size.width * 0.2,
                    child: TextField(
                      controller: _controllerKcal,
                      decoration:
                          const InputDecoration(labelText: 'kcal pour 100g : '),
                      onChanged: (value) => kcal = value,
                    ),
                  ),
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: size.width * 0.2,
                  child: TextField(
                    controller: _controllerLipides,
                    decoration: const InputDecoration(labelText: 'Lipides : '),
                    onChanged: (value) => lipides = value,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: size.width * 0.2,
                  child: TextField(

                    controller: _controllerGlucides,
                    decoration: const InputDecoration(labelText: 'Glucides : '),
                    onChanged: (value) => glucides = value,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: size.width * 0.2,
                  child: TextField(
                    controller: _controllerProteines,
                    decoration:
                        const InputDecoration(labelText: 'Protéines : '),
                    onChanged: (value) => proteines = value,
                  ),
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _setText,
                    child: Text('Ajouter'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _vider,
                    child: const Text('Vider'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(text),
            //This take a Customisable Widget eg Container, Column e.t.c
            //See Description Below for the other arguments of the Footer Component
            // are shown here
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Kcal total : " + kcalTotal.toStringAsFixed(2)),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Lipides : " +
                  lipidesTotal.toStringAsFixed(2) +
                  "g, glucides : " +
                  glucidesTotal.toStringAsFixed(2) +
                  "g, protéines : " +
                  proteinesTotal.toStringAsFixed(2) +
                  "g"),
            ),
          ],
        ),
      ),
    );
  }
}
