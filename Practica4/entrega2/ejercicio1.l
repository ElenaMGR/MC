
%{
#include <stdio.h>
int nc, np, nl;
void escribir_datos(char * etiqueta, char* texto);
void suma(char *texto);
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

({entero}|{real})(" "?"+"" "?({entero}|{real}))+	{suma(yytext);}

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

void suma(char * texto){
	double suma = 0;
	char * dig;

   printf("%s = ",texto);

   dig = strtok(texto, "+");
   while (dig != NULL){
      suma += atof(dig);
      dig = strtok (NULL, "+");
   }

	printf("%.2f",suma);
}
