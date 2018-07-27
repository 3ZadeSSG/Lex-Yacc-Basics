%{
#include<stdio.h>
void yyerror(char*);
int yylex();
int sym[26];
%}
%left '+' '-'  // left associative operators
%left '*' '/' // '*' and '/' have higher priority
%token NUM ID
%%
SL: SL S '\n' //augmented production
|
;
S: E {printf("%d\n",$1);} //S-> ID=E|E
| ID '=' E {sym[$1]=$3;}
;
E: NUM		//Grammar E->E+E|E-E|E*E|E/E|ID|NUM
| ID {$$=sym[$1];}
| E '+' E {$$=$1+$3;}
| E '-' E {$$=$1-$3;}
| E '*' E {$$=$1*$3;}
| E '/' E {
 if($3==0)
	yyerror("Can't divide by zero!");
 else
	$$=$1/$3;	
}
| '(' E ')' {$$=$2;}
;
%%
void yyerror(char *s){
 fprintf(stderr,"%s\n",s);
}
int main(void){
yyparse();
return 0;
}
