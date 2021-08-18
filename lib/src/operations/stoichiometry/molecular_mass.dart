
double getMolecularMass(List<dynamic> data, String formula){
  double molecularMass=0.0;
  RegExp regEx = new RegExp(r"(?=.*[A-Z])\w+");
  String construct="", constructNum="";
  double parse_1=0;
  int parse_2=0;
  for(int i=0; i<formula.length; i++){
    if(((int.tryParse(formula[i])==null) && construct.length != 0)&&(formula[i].toUpperCase()==formula[i])){
      parse_1 = getInformation(data, construct);
      construct="";
      molecularMass += parse_1;
    }
    if(((int.tryParse(formula[i])==null) && construct.length == 0)||((int.tryParse(formula[i])==null)&&formula[i].toLowerCase()==formula[i])){
      construct  += formula[i];
    }
    else if(int.tryParse(formula[i])!=null){
      for(int j=i; j<formula.length; j++){
        if(int.tryParse(formula[j])!=null){
          constructNum += formula[j];
        }else{
          break;
        }
      }
      parse_2=int.tryParse(constructNum);
      constructNum = "";
      parse_1 = getInformation(data, construct);
      construct="";
      molecularMass += (parse_1*(parse_2));
    }
  }
  if(construct.length != 0){
    parse_1 = getInformation(data, construct);
    molecularMass += parse_1;
    construct = "";
  }
  return molecularMass;
}

double getInformation(List<dynamic> data, String construct){
  String constructNum="";
  double parse_1;
  int lengthNum; 
  for(Map value in data){
    if(value['symbol']==construct){
      lengthNum = value['atomicMass'].length;
      for(int k=0; k<lengthNum; k++){
        if(value['atomicMass'][k]!="("){
          constructNum += value['atomicMass'][k];
        }else{
          parse_1 = double.tryParse(constructNum);
          constructNum="";
        }
      }
        break;
    }
  }
  return parse_1;
}