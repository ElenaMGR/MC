#!/bin/bash
# Para ejecutar: ./compilalex.sh <nombre.l> <ejecutable> <documento_probar>
echo "Eliminando veriones anteriores"
rm $2
echo "Generando lex..."
lex $1
echo "Compilando ..."
g++ -std=c++11 lex.yy.c -o $2 -ll -lm
echo "Ejecución:" $3
echo ""
./$2 $3
