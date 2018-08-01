%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include"logic.h"
extern struct symtab *symbol_lookup(char*);
int yylex();
void print_3_IMC();
void generate_3_IMC(char*,char*,char*);
void yyerror(char*);
char *token_string=NULL;
int t_index=0;
int temp_index=0;
%}
%union{
 char *operator;
 char *number;
 char *punctuation;
 struct symtab *symp;
}
%token <operator> DIV MUL ASSIGN
%token <number> NUM
%token <punctuation> LEFT_P RIGHT_P
%token <symp> ID
%left DIV MUL
%type <number> E T F
%%
SL: S '\n' {
 print_3_IMC();
}
| SL S '\n' {
 print_3_IMC();
}
;
S: ID ASSIGN E {
 generate_3_IMC($1->name,$3,"=");
 $1->value=$3;
/* strcpy($$,$3);
 strcat($$,"=");*/
}
;
E: E MUL T {
 strcat($$," ");
 strcat($$,$3);
 strcat($$," ");
 strcat($$,"*");
// generate_3_IMC($$,"","","");
}
| E DIV T{
 strcat($$," ");
 strcat($$,$3);
 strcat($$," ");
 strcat($$,"/");
 //generate_3_IMC($$,"","","");
}
| T
;
T: F
;
F: LEFT_P E RIGHT_P {
 strcat($$," ");
 strcat($$,$2);
 strcat($$," ");
 //generate_3_IMC($$,"","","");
}
| ID {
 $$=$1->name;
}
| NUM { 
 strcpy($$,$1);
 strcat($$," ");
 //generate_3_IMC($$,"","","");
}
;
%%
void yyerror(char *s){
 fprintf(stderr,"%s\n",s);
}
void print_3_IMC(){
 printf("Tokenized string: %s\n",token_string);
 int i=0;
 for(i=0;i<t_index;i++){
   printf("%s %s %s",tuples[i].result,tuples[i].operand_left,tuples[i].operators);
 }
 t_index=0;
 temp_index=0;
 token_string=NULL;
}
void generate_3_IMC(char *result,char *operand_left,char *operators){
 tuples[t_index].result=result;
 tuples[t_index].operand_left=operand_left;
 tuples[t_index++].operators=operators;
}
int main(void){
 yyparse();
 return 0;
}
