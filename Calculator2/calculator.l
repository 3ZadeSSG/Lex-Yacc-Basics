%{
#include<stdlib.h>
#include "y.tab.h"
void yyerror(char*);
%}
%%
[0-9]+ {
yylval=atoi(yytext);
return NUM;
}
[a-z] {
 yylval=*yytext - 'a';
 return ID;
}
[-+*=()/\n] return *yytext;
[ \t] ;
. yyerror("Invalid character!");
%%
int yywrap(void){
return 1;
}
