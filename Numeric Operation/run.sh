yacc -d numeric.y
lex numeric.l
cc lex.yy.c y.tab.c -o outputFile -lfl -g
