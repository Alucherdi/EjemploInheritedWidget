import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  title: "Test application",
  theme: ThemeData(
    primarySwatch: Colors.pink
  ),
  home: Scaffold(
    body: SafeArea(child: Home())
  )
));

/* 
  Home será el padre de los widgets a los que les compartiremos la información, es un statefulWidget para
  poder actualizar la data que queremos compartir y verificar si la modificación se ve reflejada en los 
  demas dependientes de ese modelo
*/
class Home extends StatefulWidget {  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int counter = 3;
  
  @override
  Widget build(BuildContext context) {
    return Container(

      // Se maneja el InheritedWidget como padre de los widgets que compartan la información
      child: Center(child: Shower(
        counter: counter,
        addCounter: () => setState(() => counter++),
        child: ButtonText()
      ))
    );
  }
}

class ButtonText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Se obtienen los valores del padre
    int counter = Shower.of(context).counter;
    var addCounter = Shower.of(context).addCounter;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
          onPressed: () => addCounter(),
          child: Text(counter.toString())
        ),
        ExtraData()
      ]
    );
  }
}

class ExtraData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Se obtienen los valores del padre, la magia aquí es que Shower no es padre directo, es el padre del padre, y aún funciona
    int counter = Shower.of(context).counter;

    return Text("Special text because inherits counter: $counter");
  }
}

class Shower extends InheritedWidget {
  // Aquí definimos los parametros a compartir
  final int counter;
  final addCounter;

  // Siempre debe llevar el hijo o la key como parametro de referencia
  Shower({Widget child, this.counter, this.addCounter}) : super(child: child);

  /* 
    Abajo hacemos la validación boleana de que parametros 
    son los que deben cambiar para actualizar el objeto, 
    le mando true porque quiero que todos sean el trigger de la actualización
  */
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true; 
  
  // #OPCIONAL# Si quieres obtener los valores solo con obtener la referencia del contexto crea éste helper 
  static Shower of(BuildContext context) =>
    context.inheritFromWidgetOfExactType(Shower);
}