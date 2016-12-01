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
void opUnaria(char *texto,char fun);
void opBinaria(string texto);
%}

      /*----- Alias ----------------*/
digito	[0-9]
entero	{digito}+
real	{entero}"."{entero}
real2	{real}[eE][\+\-]?{entero}
numero	{entero}|{real}|{real2}
suma (" "?("+"|"-")" "?({entero}|{real}))
producto (" "?("*"|"/")" "?({entero}|{real}))
%%

      /*----- Sección de Reglas ----------------*/

      /*Suma y resta*/
      /*Multiplicación y división*/
(("+"|"-")" "?)?({entero}|{real})" "?({suma}|{producto})+      {opBinaria(yytext);}

      /*Potencia*/
({entero}|{real})" "?"^"" "?({entero}|{real})                  {potencia(yytext);}

      /*Raíz*/
"sqrt("({entero}|{real})")"                                    {raiz(yytext);}

      /*Logaritmo*/
"log("({entero}|{real})")"                                     {opUnaria(yytext,'l');}

      /*Coseno*/
"cos("({entero}|{real})")"                                     {opUnaria(yytext,'c');}

      /*Seno*/
("sin"|"sen")"("({entero}|{real})")"                           {opUnaria(yytext,'s');}

      /*Tangente*/
"tan("({entero}|{real})")"                                     {opUnaria(yytext,'t');}


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
	string dig;
   size_t pos_ant = 0, pos;
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
      pos = texto.find_first_of("*/+-",pos_ant+1);
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
   }

   // Imprimimos la suma total
	cout<<operacion;
}

// Potencia
void potencia(char * texto){
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
}

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

// Operaciones unarias log, tan, sen, cos
void opUnaria(char *texto,char fun){
	double suma = 0;
	char * dig;
   double PI =  3.14159265;
   double val = PI / 180.0;
   dig[0] = '\0';
   printf("%s = ",texto);

   // Copio en dig el número al que quiero hacerle la operación, quitando "log(),cos(),sin(),tan()"
   strncpy( dig, texto+4,strlen(texto));

   // Hago el cálculo
   switch (fun) {
      case 'l':suma = log(atof(dig)*1.0); break;;
      case 'c':suma = cos(atof(dig)*val); break;;
      case 's':suma = sin(atof(dig)*val); break;;
      case 't':suma = tan(atof(dig)*val); break;;
   }
	printf("%f",suma);

}
