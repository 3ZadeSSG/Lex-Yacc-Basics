%{
#include<string.h>
#include<stdlib.h>
#include<stdio.h>
#include "logic.h"
int yylex();
void yyerror(char*);
char *new_temp();
void print_imc_code();
void imc_code_generator(char*,char*,char*,char*);
extern struct symtab *symbol_lookup(char*);
char *token_string=NULL;
int tuple_index=0;
int temp_index=0;
%}
%union{
 char *punctuation;
 char *operator;
 char *expr;
 struct symtab *symp;
}
%token <operator> AND OR NOT ASSIGN
%token <punctuation> LEFT_P RIGHT_P
%token <symp> ID
%left AND
%left OR
%right NOT
%type <expr> E T F
%%
SL: S '\n' {
 printf("Tokenized String: %s\n",token_string);
 token_string=NULL;
 print_imc_code();
 tuple_index=0;
 temp_index=0;
}
| SL S '\n' {
 printf("Tokenized String: %s\n",token_string);
 print_imc_code();
 token_string=NULL;
 tuple_index=0;
 temp_index=0;
}
;
S: ID ASSIGN E {
 imc_code_generator($1->name,$3,"","");
 $1->value=$3;
}
| E
;
E: E OR T {
 $$=new_temp();
 imc_code_generator($$,$1," V ",$3);
}
| T
;
T: T AND F {
 $$=new_temp();
 imc_code_generator($$,$1," ^ ",$3);
}
| F
;
F: LEFT_P E RIGHT_P {
 strcpy($$,$2);
}
| NOT LEFT_P E RIGHT_P {
 strcpy($$," ~");
 strcat($$,$3);
}
| ID {
 $$=$1->name;
}
;
%%
char *new_temp(){
 char *temp=(char*)malloc(sizeof(char)*20);
 sprintf(temp,"t%d",++temp_index);
 return temp;
}
void print_imc_code(){
 int index=0;
 for(index=0;index<tuple_index;index++){
  printf("%s = %s %s %s\n",tuples[index].result,tuples[index].operand_left,tuples[index].operators,tuples[index].operand_right);
 }
 printf("\n===================\n"); 
}
void imc_code_generator(char *result,char *operand_left,char *operators,char *operand_right){
 tuples[tuple_index].result=result;
 tuples[tuple_index].operand_left=operand_left;
 tuples[tuple_index].operand_right=operand_right;
 tuples[tuple_index].operators=operators; 
 tuple_index++;
}
void yyerror(char *s){
 fprintf(stderr,"%s\n",s);
}
int main(int *argc,char **argv){
 yyparse();
 return 0;
}
