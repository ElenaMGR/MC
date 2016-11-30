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
void funcion(char *texto,char fun);
void op(string texto);
%}

      /*----- Alias ----------------*/
digito	[0-9]
entero	{digito}+
real	{entero}"."{entero}
real2	{real}[eE][\+\-]?{entero}
numero	{entero}|{real}|{real2}
signos ("."|","|";")
suma (" "?("+"|"-")" "?({entero}|{real}))
producto (" "?("*"|"/")" "?({entero}|{real}))
%%

      /*----- Sección de Reglas ----------------*/
(("+"|"-")" "?)?({entero}|{real})({suma}|{producto})+                               {op(yytext);}
      /*Suma y resta*/
      /*(("+"|"-")" "?)?({entero}|{real})(" "?("+"|"-")" "?({entero}|{real}))+	{suma(yytext);}*/
      /*Multiplicación y división*/
      /*({entero}|{real})(" "?("*"|"/")" "?({entero}|{real}))+  {producto(yytext);}*/
      /*Potencia*/
({entero}|{real})" "?"^"" "?({entero}|{real})           {potencia(yytext);}
      /*Raíz*/
"sqrt("({entero}|{real})")"                             {raiz(yytext);}
      /*Logaritmo*/
"log("({entero}|{real})")"                              {funcion(yytext,'l');}
      /*Coseno*/
"cos("({entero}|{real})")"                              {funcion(yytext,'c');}
      /*Seno*/
("sin"|"sen")"("({entero}|{real})")"                    {funcion(yytext,'s');}
      /*Tangente*/
"tan("({entero}|{real})")"                              {funcion(yytext,'t');}


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

void op(string texto){
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
//Suma de polinomios sencillos
void suma(string texto){
	double suma = 0;
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
      pos = texto.find_first_of("+-",pos_ant+1);
      dig = texto.substr(pos_ant,pos-pos_ant);
      elemento.push_back(dig);
      pos_ant=pos;
   }

   // Realizamos el cálculo
   for (int i =0; i< elemento.size(); i++)
      suma += stod(elemento[i]);

   // Imprimimos la suma total
	cout<<suma;
}

void producto(string texto){
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
      pos = texto.find_first_of("*/",pos_ant+1);
      dig = texto.substr(pos_ant,pos-pos_ant);
      elemento.push_back(dig);
      pos_ant=pos;
   }

   // Realizamos el cálculo
   operacion = stod(elemento[0]);
   for (int i = 1; i< elemento.size(); i++){
      if (elemento[i].at(0)=='*')
         operacion *= stod(elemento[i].substr(1,elemento[i].size()-1));
      if (elemento[i].at(0)=='/')
         operacion /= stod(elemento[i].substr(1,elemento[i].size()-1));
   }

   // Imprimimos la suma total
	cout<<operacion;
}

void potencia(char * texto){
   double suma = 0;
   double base,exponente;
	char * dig;

   cout<<texto<<" = ";

   dig = strtok(texto, "^");
   base = atof(dig)*1.0;
   dig = strtok(NULL, "^");
   exponente = atof(dig)*1.0;

   suma = pow(base,exponente);

	cout<<suma;
}

void raiz(char * texto){
	double suma = 0;
	char * dig;

   cout<<texto<<" = ";

   // sqrt( = 5 caracteres, por lo que size() - 5 + 1 (ultimo parentesis)  = nº de numeros
   strncpy( dig, texto+5,strlen(texto)-6);
   suma = sqrt(atof(dig)*1.0);

	cout<<suma;
}


void funcion(char *texto,char fun){
	double suma = 0;
	char * dig;
   double PI =  3.14159265;
   double val = PI / 180.0;
   dig[0] = '\0';
   printf("%s = ",texto);

// log( = 4 caracteres, por lo que size() - 4 + 1 (ultimo parentesis)  = nº de numeros
   strncpy( dig, texto+4,strlen(texto));
   dig[strlen(texto)-5]='\0';
   switch (fun) {
      case 'l':suma = log(atof(dig)*1.0); break;;
      case 'c':suma = cos(atof(dig)*val); break;;
      case 's':suma = sin(atof(dig)*val); break;;
      case 't':suma = tan(atof(dig)*val); break;;
   }
	printf("%f",suma);

}
