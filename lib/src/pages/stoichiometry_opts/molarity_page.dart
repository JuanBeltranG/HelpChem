import 'package:flutter/material.dart';
import 'package:help_chem/src/operations/stoichiometry/molecular_mass.dart';
import 'package:help_chem/src/operations/stoichiometry/operations_stoichiometry.dart';
import 'package:help_chem/src/providers/elements_providers.dart';

import 'package:help_chem/src/utils/hex_color_util.dart';

class MolarityPage extends StatefulWidget {
  @override
  _MolarityState createState() => _MolarityState();
}

class _MolarityState extends State<MolarityPage> {
  String _formula="";
  double _volumen=0;
  double _masa=0;
  double _molaridad=0;
  double _pm=0;
  double _resultado=0;
  List<dynamic> _data=[];

  final ButtonStyle styleCalcular = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20), 
    primary: getColorFromHex('#DA4573'), 
    shape: StadiumBorder(),
    minimumSize: Size(200, 50)  
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColorFromHex('#DA4573'),
        title: Text('Molaridad'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        children: <Widget>[
          _inputFormula(),
          SizedBox(
            height: 20.0,
          ),
          _inputVolumen(),
          SizedBox(height: 20.0),
          _inputMasa(),
          SizedBox(height: 20.0),
          _inputMolaridad(),
          SizedBox(height: 30.0),
          bringData(),
        ],
      ),
    );
  }

  Widget bringData(){
    return FutureBuilder(
        future: elementsProvider.cargarData(), // En esta parte del codigo lo que se está realizando es de la instancia creada obtener el metodo que retorna un future
        initialData: [], // esta parte es importante porque nos ayuda a siempre tener algo en el data sin tener errores de compilación cuando se ejecuta el método ForEach para obtener los elementos
        builder: ( BuildContext context, AsyncSnapshot<List<dynamic>> snapshot ){
          print( snapshot.data ); //Nos permitira visualizar la información del snapshot que es la traida del json      
          return _botonCalcular(snapshot.data);
        },  
      );
  }

  Widget _inputFormula() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        hintText: 'Formula quimica',
        labelText: 'Formula quimica',
        icon: Icon(
          Icons.science_outlined,
          color: Colors.black,
        ),
        helperText: 'Ingresa la formula quimica de la disolución',
      ),
      onChanged: (valor) {
        _formula = valor;
        print(_formula);
      },
    );
  }

  Widget _inputVolumen() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        hintText: 'Volumen total de la disolución',
        labelText: 'Volumen de disolución',
        icon: Icon(
          Icons.opacity,
          color: Colors.black,
        ),
        helperText: 'Ingresa el volumen (En caso de tener este dato)',
        counter: Text('Unidades: L'),
      ),
      onChanged: (valor) {
        _volumen = double.parse(valor);
        print(_volumen);
      },
    );
  }

  Widget _inputMasa() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        hintText: 'Masa del soluto',
        labelText: 'Masa del soluto',
        icon: Icon(
          Icons.straighten,
          color: Colors.black,
        ),
        helperText: 'Ingresa la masa (En caso de tener este dato)',
        counter: Text('Unidades: gr'),
      ),
      onChanged: (valor) {
        _masa = double.parse(valor);
        print(_masa);
      },
    );
  }

  Widget _inputMolaridad() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        hintText: 'Molaridad',
        labelText: 'Molaridad',
        icon: Icon(
          Icons.biotech,
          color: Colors.black,
        ),
        helperText: 'Ingresa la molaridad (En caso de tener este dato)',
        counter: Text('Unidades: /'),
      ),
      onChanged: (valor) {
        _molaridad = double.parse(valor);
        print(_molaridad);
      },
    );
  }

  Widget _botonCalcular(List<dynamic> data) {
    return ElevatedButton(

      style: styleCalcular,
      onPressed: () {
        print(getMolecularMass(data, _formula));
        _pm=getMolecularMass(data, _formula);
        if(_molaridad==0){
          _resultado=getMolarity(_volumen, _masa,_pm);
        }
        else if(_volumen==0){
          _resultado=getVolume(_molaridad, _masa, _pm);
        }
        else if(_masa==0){
          _resultado=getMass(_molaridad,_pm,_volumen);
        }
        _mostrarResultado(context);
      },
      child: Text(
        'Calcular',
        
      ),
    );
  }

  void _mostrarResultado(BuildContext context){

    showDialog(
      context: context,
      barrierDismissible: false, //Para poder quitar la alerta al presionar fuera de la alerta
      builder : (context) {

        return AlertDialog(
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
          title: Text('Resultado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('$_resultado'),
              FlutterLogo( size: 100.0 )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );

      }
    );

  }
}
