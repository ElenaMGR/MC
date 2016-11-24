
%{
#include <stdio.h>
#include <math.h>
int nc, np, nl;
void escribir_datos(char * etiqueta, char* texto);
void suma(char *texto);
void potencia(char *texto);
void raiz(char *texto);
%}
letra	[a-zA-Z]
digito	[0-9]
entero	{digito}+
real	{entero}"."{entero}
real2	{real}[eE][\+\-]?{entero}
numero	{entero}|{real}|{real2}
alfanumerico	[a-zA-Z0-9]
dominios (es|com|org|net)
signos ("."|","|";")
%%

{letra}[a-zA-Z0-9".""-""_"]*"@"{letra}+("."{letra}+)+{signos}?	{escribir_datos("Correo",yytext);}

({entero}|{real})(" "?("+"|"-")" "?({entero}|{real}))+	{suma(yytext);}
({entero}|{real})" "?"^"" "?({entero}|{real})           {potencia(yytext);}
"sqrt("({entero}|{real})")"                             {raiz(yytext);}

   /*[^ \t\n]+   { np++; nc += yyleng; }*/
   /*[ \t]+      { nc += yyleng; }*/
   /*\n          { nl++; nc++; }*/

%%

int main (int argc, char *argv[]) {

  if (argc == 2) {
    yyin = fopen (argv[1], "rt");

    if (yyin == NULL) {
      printf ("El fichero %s no se puede abrir\n", argv[1]);
      exit (-1);
    }
  }else
    yyin = stdin;

    nc = np = nl = 0;
    yylex ();
    //escribir_datos(correos,np,nl);
    return 0;
}

void escribir_datos (char * etiqueta, char* texto) {
  if(texto[strlen(texto)-1] == '.' ||texto[strlen(texto)-1] == ','||texto[strlen(texto)-1] == ';')
    texto[strlen(texto)-1] = '\0';

  printf ("%s: %s\n",etiqueta,texto);
}

// Suma de polinomios sencillos
void suma(char * texto){
	double suma = 0;
	char * dig;

   printf("%s = ",texto);

   int i=0;
   int j=0;
   double signo[strlen(texto)];
   signo[0] = 1;
   char operador [strlen(texto)];

   for(i=0; i < strlen(texto);i++){
     switch(texto[i]) {
       case '+': signo[j+1]= 1;
                 operador[j] = texto[i];
                 j++;
          break;
       case '-': signo[j+1]= -1;
                 operador[j] = texto[i];
                 j++;
          break;
    };
   }

   j = 0;
   char * aux = malloc(sizeof(char)*2);
   aux[0] = operador[j];
   aux[1] = '\0';

   dig = strtok(texto, aux);
   while (dig != NULL){
        suma += atof(dig)*signo[j];
        j++;
        aux[0]= operador[j];
        dig = strtok (NULL, aux);
    }

	printf("%.2f",suma);
}

void potencia(char * texto){
	double suma = 0;
  double base,exponente;
	char * dig;

  printf("%s = ",texto);

  dig = strtok(texto, "^");
  base = atof(dig)*1.0;
  dig = strtok(NULL, "^");
  exponente = atof(dig)*1.0;

  suma = pow(base,exponente);

	printf("%.2f",suma);
}

void raiz(char * texto){
	double suma = 0;
//  double aux;
	char * dig;

  printf("%s = ",texto);

// sqrt( = 5 caracteres, por lo que size() - 5 + 1 (ultimo parentesis)  = nº de numeros
  strncpy( dig, texto+5,strlen(texto)-6);
  suma = sqrt(atof(dig)*1.0);

	printf("%.2f",suma);
}
