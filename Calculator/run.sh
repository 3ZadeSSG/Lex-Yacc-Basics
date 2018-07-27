yacc -d calculator.y
lex calculator.l
cc lex.yy.c y.tab.c -o outputFile -lfl -g
