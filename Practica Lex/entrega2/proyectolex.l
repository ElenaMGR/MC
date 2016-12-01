      /*----- Sección de Declaraciones --------------*/
%{
#include <stdio.h>
#include <math.h>
#include <string>
#include <iostream>
#include <vector>
using namespace std;

void suma(string texto);
void producto(string texto);
void potencia(char * texto);
void raiz(char * texto);
void trig(string texto);
void opBinaria(string texto);
%}

      /*----- Alias ----------------*/
digito	[0-9]
entero	{digito}+
real	{entero}"."{entero}
numero	{entero}|{real}
suma (" "?("+"|"-")" "?({entero}|{real}))
producto (" "?("*"|"/")" "?"-"?" "?({entero}|{real}))
potencia " "?"^"" "?"-"?" "?{numero}
log "log("{numero}")"
cos "cos("{numero}")"
sin ("sin"|"sen")"("{numero}")"
tan "tan("{numero}")"
%%

      /*----- Sección de Reglas ----------------*/

      /*Suma y resta*/
      /*Multiplicación y división*/
      /*Potencia*/
(("+"|"-")" "?)?{numero}" "?({suma}|{producto}|{potencia})+      {opBinaria(yytext);}

      /*Raíz*/
("sqrt("{numero}")")                                  {raiz(yytext);}

      /*Operaciones trigonométricas*/
({log}|{cos}|{sin}|{tan})                             {trig(yytext);}


%%

      /*----- Sección de Procedimientos --------*/

int main (int argc, char *argv[]) {
   if (argc == 2) {
      yyin = fopen (argv[1], "rt");

      if (yyin == NULL) {
         cout<<"El fichero"<< argv[1] <<" no se puede abrir"<<endl;
         exit (-1);
      }
   }else
      yyin = stdin;

   yylex ();

   return 0;
}

// Operaciones binarias suma, resta, multiplicación y división
void opBinaria(string texto){
   double operacion = 0;
   double base,exponente;
	string dig;
   size_t pos_ant = 0, pos;
   //int pos_ant = 0, pos;
   size_t it = 0;

   cout<<texto<<" = ";

   vector<string> elemento;

   // Eliminamos los espacios, si los hay
   while (it != string::npos){
      it = texto.find_first_of(" ");
      if (it<string::npos)
         texto.erase(it,1);
   }

   // Extraemos las operaciones
   while (pos_ant < texto.size()){
      if ((texto.at(pos_ant)=='*'||texto.at(pos_ant)=='/'||texto.at(pos_ant)=='^') && texto.at(pos_ant+1)=='-')
         pos = texto.find_first_of("*/+-^",pos_ant+2);
      else
         pos = texto.find_first_of("*/+-^",pos_ant+1);
      dig = texto.substr(pos_ant,pos-pos_ant);
      elemento.push_back(dig);
      pos_ant=pos;
   }

   // Realizamos el cálculo
   operacion = stod(elemento[0]);
   for (int i = 1; i< elemento.size(); i++){
      if (elemento[i].at(0)=='-' || elemento[i].at(0)=='+')
         operacion += stod(elemento[i]);
      if (elemento[i].at(0)=='*')
         operacion *= stod(elemento[i].substr(1,elemento[i].size()-1));
      if (elemento[i].at(0)=='/')
         operacion /= stod(elemento[i].substr(1,elemento[i].size()-1));
      if (elemento[i].at(0)=='^'){
         base = operacion;
         exponente = stod(elemento[i].substr(1,elemento[i].size()-1));
         operacion = pow(base,exponente);
      }
   }

   // Imprimimos la suma total
	cout<<operacion;
}

// Potencia
/*void potencia(char * texto){
   double suma = 0;
   double base,exponente;
	char * dig;

   cout<<texto<<" = ";

   // Divido el texto en base ^ exponente
   dig = strtok(texto, "^");
   base = atof(dig)*1.0;
   dig = strtok(NULL, "^");
   exponente = atof(dig)*1.0;

   // Calculo la potencia
   suma = pow(base,exponente);

	cout<<suma;
}*/

// Raíz cuadrada
void raiz(char * texto){
	double suma = 0;
	char * dig;

   cout<<texto<<" = ";

   // Copio en dig el número al que quiero hacerle la raiz cuadrada, quitando "sqrt()"
   strncpy( dig, texto+5,strlen(texto)-6);
   // Calculo la raíz cuadrada
   suma = sqrt(atof(dig)*1.0);

	cout<<suma;
}


// Operaciones trigonométricas log, tan, sen, cos
void trig(string texto){
   double operacion = 0;
	double dig;
   size_t pos_ant = 0, pos, it = 0;
   double PI =  3.14159265;
   double val = PI / 180.0;

   cout<<texto<<" = ";

   // Eliminamos los espacios, si los hay
   while (it != string::npos){
      it = texto.find_first_of(" ");
      if (it<string::npos)
         texto.erase(it,1);
   }

   //Obtenemos el número
   dig = stod(texto.substr(4,texto.size()-5));

   // Realizamos el cálculo
   if (texto.substr(0,3)=="log")
      operacion=log(dig*1.0);
   else if (texto.substr(0,3)=="cos")
      operacion=cos(dig*val);
   else if (texto.substr(0,3)=="sin" || texto.substr(0,3)=="sen")
      operacion=sin(dig*val);
   else if (texto.substr(0,3)=="tan")
      operacion=tan(dig*val);

   // Imprimimos la suma total
	cout<<operacion;

}
