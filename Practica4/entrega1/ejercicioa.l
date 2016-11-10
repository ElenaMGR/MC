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

%%
      /*----- Sección de Reglas ----------------*/

.                                      {}
   /*Direcciones de correo electrónico*/
{letra}({letra}|{digito}|{signos})+"@"{letra}+("."{letra}+)+                           { escribir_datos("Correo", yytext); }

   /*Direcciones páginas web*/
("www."|"http://"|"https://")?[^" "]+("."{dominios})+                                  { escribir_datos("Web", yytext); }

   /*Fechas*/
{digito}{2}("/"|"-"){digito}{2}("/"|"-")({digito}{2}|{digito}{4})                      { escribir_datos("Fecha", yytext); }

   /*Números de teléfono*/
("+"{digito}+{stf})?{tlf})                                                             { escribir_datos("Telf", yytext); }

   /*Matrículas*/
(({mayus}{2}|{mayus}){stf}?{digito}{4}{stf}?{mayus}{2}|{digito}{4}{stf}?{mayus}{3})    { escribir_datos("Matrícula", yytext); }

   /*Códigos postales*/
{digito}{5}                                                                            { escribir_datos("CP", yytext); }

   /*NIF*/
{digito}{8}{stf}?{letra}?                                                              { escribir_datos("NIF", yytext); }

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
   printf ("%s: %s\n",nombre,texto);
}
