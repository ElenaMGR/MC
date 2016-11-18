#!/bin/bash
echo "Eliminando veriones anteriores"
rm $2
echo "Generando lex..."
lex $1
echo "Compilando ..."
gcc lex.yy.c -o $2 -ll
echo "Ejecución:" $3
echo ""
./$2 $3
