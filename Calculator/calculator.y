%{
#include<stdio.h>
void yyerror(char*);
int yylex(void);
%}
%token NUM
%%
SL: SL S '\n' {printf("Result: %d\n",$2);}  //augmented production
|
;
S: NUM {$$=$1;}		//original grammar E->E+E|E-E|NUMBER
| S '+' S {$$=$1+$3;}
| S '-' S {$$=$1-$3;}
;
%%
void yyerror(char *s){
fprintf(stderr,"%s\n",s);
}
int main(void){
yyparse();
return 0;
}
