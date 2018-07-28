%{
#include "numeric.h" //definition of symbol table is here
#include <stdio.h> //for displaying outout in console aka terminal
#include <stdlib.h>
#include <string.h>
int yylex(); //will be fired off automaticaly by yacc to read lexeme using lex
void yyerror(char*);
char *new_temp(); //new tuple generator
void print_imc_code();
void imc_code_generator(char*,char*,char*,char*);
extern struct symtab *symbol_lookup(char*); 
char *token_string=NULL; //tokenized string 
int tuple_index=0; //number of quadruple entries
int temporary_generated=0; //temporary generated tuple count
%}
%union{
 char *number;
 char *operator;
 char *parenthesis;
 struct symtab *symp;
}
%token <number> NUM
%token <operator> ADD SUB MUL DIV ASSIGN
%token <parenthesis> LEFT_P RIGHT_P
%token <symp> ID
%right ADD SUB MUL DIV
%nonassoc UMINUS
%type <number> E F G H I
%%
/*if augmented priduction reached then print tokenized string and 3 address code*/
SL: S '\n' {
 printf("Tokenized String: %s\n",token_string);
 token_string=NULL;
 print_imc_code();
 tuple_index=temporary_generated=0;
}
| SL S '\n'{
 printf("Tokenized String: %s\n",token_string);
 token_string=NULL;
 print_imc_code();
 tuple_index=temporary_generated=0;
}
;
S: ID ASSIGN E{
 imc_code_generator($1->name,$3,"","");
 $1->value=$3;
}
| E
;
E: E SUB F{
 $$=new_temp(); 
 imc_code_generator($$,$1,"-",$3);
}
| F
;
F: F ADD G{
 $$=new_temp();
 imc_code_generator($$,$1,"+",$3);
}
| G
;
G: G MUL H {
 $$=new_temp();
 imc_code_generator($$,$1,"*",$3);
}
| H
;
H: H DIV I {
 $$=new_temp();
 imc_code_generator($$,$1,"/",$3);
}
| I
;
I: LEFT_P E RIGHT_P {
 strcpy($$,$2);
}
| SUB E %prec UMINUS{
/* $$=strdup("-");
 $$=strcat($$,$2);*/
 strcpy($$,"-");
 strcat($$,$2);
}
| ID{
 $$=$1->name;
}
| NUM
;
%%
char *new_temp(){
 char *temp=(char*)malloc(sizeof(char)*21);
 sprintf(temp,"t%d",++temporary_generated);
 return temp;
}
void print_imc_code(){
 int index=0;
 printf("Intermediate code: \n");
 for(index=0;index<tuple_index;index++){
  printf("%s = %s %s %s\n",tuples[index].result,tuples[index].operand_left,tuples[index].operators,tuples[index].operand_right);
 }
 printf("\n");
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
