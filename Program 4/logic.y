%{
#include<stdlib.h>
#include<string.h>
#include<stdio.h>
#include "logic.h"
int yylex();
void yyerror(char*);
void print_3_IMC();
void generate_3_IMC(char*,char*,char*,char*);
char *new_temp();
extern struct symtab *symbol_lookup(char*); //definition in lex file
char *token_string=NULL;
int t_index=0;
int temp_index=0;
%}
%union{
 char *operator;
 char *punctuation;
 char *number;
 struct symtab *symp;
 char *expr;
}
%token <number> NUM
%token <operator> LESS_THAN GREATER_THAN ASSIGN NOT_EQUAL
%token <punctuation> LEFT_P RIGHT_P
%token <symp> ID
%type  <number> E T F
%%
SL: S '\n' {
 printf("Tokenized String: %s\n",token_string);
 print_3_IMC();
}
| SL S '\n' {
 printf("Tokenized String: %s\n",token_string);
 print_3_IMC();
}
;
S: ID ASSIGN E {
 generate_3_IMC($1->name,$3,"","");
 $1->value=$3;
}
| E
;
E: E GREATER_THAN T {
 $$=new_temp();
 generate_3_IMC($$,$1," > ",$3);
}
| T
;
T: T LESS_THAN F {
 $$=new_temp();
 generate_3_IMC($$,$1," < ",$3);
}
| F
;
F: LEFT_P E RIGHT_P {
 strcpy($$,$2);
}
| NOT_EQUAL LEFT_P E RIGHT_P {
 $$=new_temp();
 generate_3_IMC("$$","","! ",$3);
// strcpy($$,"! ");
// strcat($$,$2);
}
| ID {
 $$=$1->name;
}
| NUM
;
%%
void yyerror(char *s){
 fprintf(stderr,"%s\n",s);
}
char *new_temp(){
 char *temp=(char*)malloc(sizeof(char)*50);
 sprintf(temp,"t%d",++temp_index);
 return temp;
}
void print_3_IMC(){
 int i=0;
 for(i=0;i<t_index;i++){
  printf("\n%s = ",tuples[i].result);
  printf("%s ",tuples[i].operand_left);
  printf("%s ",tuples[i].operators);
  printf("%s ",tuples[i].operand_right);
 }
 t_index=0;
 temp_index=0;
 token_string=NULL;
}
void generate_3_IMC(char *result,char *operand_left,char *operators,char *operand_right){
 tuples[t_index].result=result;
 tuples[t_index].operand_left=operand_left;
 tuples[t_index].operand_right=operand_right;
 tuples[t_index].operators=operators;
 t_index++;
}
int main(int *argc,char **argv){
 yyparse();
 return 0;
}
