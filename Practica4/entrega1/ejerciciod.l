   /*----- Sección de Declaraciones --------------*/

%{
#include <stdio.h>

int nc, np, nl;
void invertir(char * palabra);
%}

%%
   /*----- Sección de Reglas ----------------*/

[^ \t\n]+         { printf ("%s -",yytext); invertir(yytext); printf (" %s \n",yytext); }
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

   nc = np = nl = 0;
   yylex ();


   return 0;
}

void invertir(char * palabra){
   int i;
   char c;
   int len = strlen(palabra);
   for (i=0; i< len/2; i++) {
      c = palabra[i];
      palabra[i] = palabra[len - i - 1];
      palabra[len - i - 1] = c;
  }

}
