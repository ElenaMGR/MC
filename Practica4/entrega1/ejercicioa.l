      /*----- Sección de Declaraciones --------------*/

%{
#include <stdio.h>

void escribir_datos (char * nombre, char* texto);
%}

      /*----- Alias ----------------*/
letra       [a-zA-Z]
mayus       [A-Z]
digito      [0-9]
signos      ("."|"_"|"-")
dominios    (es|com|eu|org|net|gov|edu|info|int|mil|jobs|museum)
stf         (" "|"-")
tlf         ({digito}{9}|{digito}{3}{stf}({digito}{6}|{digito}{3}{stf}{digito}{3}|{digito}{2}{stf}{digito}{2}{stf}{digito}{2})
delim       (" "|";"|","|"."|"\n"|"\t")

%%
      /*----- Sección de Reglas ----------------*/

   /*Direcciones de correo electrónico*/
{letra}({letra}|{digito}|{signos})*"@"{letra}+("."{letra}+)+{delim}       { escribir_datos("Correo", yytext); }

   /*Direcciones páginas web*/
("www."|"http://"|"https://")?{letra}[^ \t\n"@"]*("."{dominios})+{delim}  { escribir_datos("Web", yytext); }

   /*Fechas*/
{digito}{2}("/"|"-"){digito}{2}("/"|"-")({digito}{2}|{digito}{4}){delim}  { escribir_datos("Fecha", yytext); }

   /*Números de teléfono*/
("+"{digito}{2}{stf})?{tlf}){delim}                                       { escribir_datos("Telf", yytext); }

   /*Matrículas*/
(({mayus}{2}|{mayus}){stf}?{digito}{4}{stf}?({mayus}{2}|{mayus})|{digito}{4}{stf}?{mayus}{3})  { escribir_datos("Matrícula", yytext); }

   /*Códigos postales*/
{digito}{5}{delim}                                                        { escribir_datos("CP", yytext); }

   /*NIF*/
{digito}{8}{stf}?{mayus}{delim}                                           { escribir_datos("NIF", yytext); }

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

   yylex ();

   return 0;
}

void escribir_datos (char * nombre, char* texto) {
   if (texto[strlen(texto)-1]==' '||texto[strlen(texto)-1]==';'||texto[strlen(texto)-1]=='.'||texto[strlen(texto)-1]==','
   ||texto[strlen(texto)-1]=='\n'||texto[strlen(texto)-1]=='\t')
      texto[strlen(texto)-1]='\0';
   printf ("%s: %s\n",nombre,texto);
}
