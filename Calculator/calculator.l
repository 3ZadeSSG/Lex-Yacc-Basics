%{
#include<stdlib.h>
#include "y.tab.h"
void yyerror(char*);
%}
%%
[0-9]+ {yylval=atoi(yytext); return NUM;}
[-+\n] {return *yytext;}
[ \t] ;
. yyerror("Invalid character");
%%
int yywrap(void){
return 1;
}

