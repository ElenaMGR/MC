      /*----- Sección de Declaraciones --------------*/

%{
#include <stdio.h>

int nmayus, nminus, npal, nentero, nreal, sumInt;
double sumReal;
void escribir_datos (int dato1, int dato2, int dato3, int dato4, int dato5, int dato6, double dato7);
void mostrar_datos (char * nombre, char* texto);
%}
      /*----- Alias ----------------*/
delim       (";"|","|".")
mayuscula [A-Z]
minuscula [a-z]
letra	[a-zA-Z]
digito   [0-9]
entero   {digito}+
real  {entero}.{entero}
real2  ({real}|{entero})[eE](\+|\-)?{entero}
numero  {entero}|{real}|{real2}

%%
      /*----- Sección de Reglas ----------------*/
   /*secuencias de caracteres escritas completamente en mayúsculas*/
{mayuscula}+{delim}?                                  { nmayus++;mostrar_datos("mayus",yytext);}

   /*secuencias de caracteres escritas completamente en minúsculas.*/
{minuscula}+{delim}?                                  { nminus++;mostrar_datos("minus",yytext);}

   /*secuencias de caracteres que mezclen mayúsculas y minúsculas.*/
({mayuscula}|{minuscula})+{delim}?                    { npal++;mostrar_datos("Mayu y minus",yytext);}

   /*Contar el número de números enteros.*/
   /*Calcular la suma de todos los números enteros encontrados.*/
{entero}{delim}?                                     { nentero++;mostrar_datos("Num entero",yytext); sumInt+=atoi(yytext);}

   /*Contar el número de números reales.*/
   /*Calcular la suma de todos los números reales encontrados.*/
({real}|{real2}){delim}?                              { nreal++;mostrar_datos("Num real",yytext); sumReal+=atof(yytext);}



[^ \t\n]+         { }
[ \t]+            { }
\n                { }


%%
      /*----- Sección de Procedimientos --------*/

int main (int argc, char *argv[]) {
   if (argc == 2) {
      yyin = fopen (argv[1], "rt");
      if (yyin == NULL) {
         printf ("El fichero %s no se puede abrir\n", argv[1]);
         exit (-1);
      }
   }
   else yyin = stdin;

   nmayus = nminus = npal = nentero = nreal = sumInt = sumReal = 0;
   yylex ();
   escribir_datos(nmayus,nminus,npal,nentero, nreal, sumInt, sumReal);

   return 0;
}

void mostrar_datos (char * nombre, char* texto) {
   if (texto[strlen(texto)-1]==';'||texto[strlen(texto)-1]=='.'||texto[strlen(texto)-1]==',')
      texto[strlen(texto)-1]='\0';
   printf ("%s: %s\n",nombre,texto);
}

void escribir_datos (int dato1, int dato2, int dato3, int dato4, int dato5, int dato6, double dato7) {
   printf ("Secuencias de caracteres escritas completamente en mayúsculas=%d\n",dato1);
   printf ("Secuencias de caracteres escritas completamente en minúscula=%d\n",dato2);
   printf ("Secuencias de caracteres mezclan mayúscula y mínuscula=%d\n",dato3);
   printf ("Números enteros=%d\n",dato4);
   printf ("Números reales=%d\n",dato5);
   printf ("Suma enteros=%d\n",dato6);
   printf ("Suma reales=%f\n",dato7);
}
