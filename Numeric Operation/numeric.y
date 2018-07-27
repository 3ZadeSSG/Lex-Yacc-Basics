%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "numeric.h"
void yyerror(char*);
int yylex();
char *token_string=NULL;
int tuple_index=0;
int temporary_generated=0;
void print_imc_code(void);
void imc_code_generator(char*,char*,char*,char*);
extern struct symtab *symbol_lookup(char*);
char *new_temp();
%}
%union{
 char *number;
 char operator;
 char parenthesis;
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
/*
Grammar with augmented production:-
SL-> SL S | S
S-> ID=E|E
E-> E-F|F
F-> F+G|G
G-> G*H|H
H-> H/I|I
I-> (E)|ID|NUM
*/
SL: SL S '\n' {
 printf("\nTokenize String: %s\n",token_string);
 print_imc_code();
 token_string=NULL;
 tuple_index=0;
 temporary_generated=0;
}
| S '\n' {
 printf("\nTokenized String: %s\n",token_string);
 print_imc_code();
 token_string=NULL;
 tuple_index=0;
 temporary_generated=0;
}
;
S: ID ASSIGN E {
  imc_code_generator($1->name,$3,"","");
  $1->value=$3;
}
| E
;
E: E SUB F {
 $$=new_temp();
 imc_code_generator($$,$1,"-",$3);
}
| F
;
F: F ADD G {
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
 char *temp=strdup($3);
 if(0==atof(temp) && temp[0]!='0'){
   temp=symbol_lookup(temp)->value;
 }
 if(!temp||0==atof(temp)){ 
   yyerror("Cannot divide by zero!");
   exit(1);
 }
 $$=new_temp();
 imc_code_generator($$,$1,"/",$3);
}
| I
;
I: LEFT_P E RIGHT_P {
  $$=strdup($2);
}
| ID {
  $$=$1->name;
}
| SUB E %prec UMINUS {
 $$=strdup("-");
 $$=strcat($$,$2);
}
| NUM
;
%%
void yyerror(char *s){ 
 fprintf(stderr,"%s\n",s); //will go to file handle, to be printed under stderr lib function
}

char *new_temp(){
 char *temp=(char*)malloc(sizeof(20));
 sprintf(temp,"t%d",++temporary_generated); //sprintf() is used to store the string in buffer instead of output to console aka terminal
 return temp;
}

void imc_code_generator(char *result,char *operand_left,char *operators,char *operand_right){
 tuples[tuple_index].result=result;
 tuples[tuple_index].operators=operators;
 tuples[tuple_index].operand_left=operand_left;
 tuples[tuple_index].operand_right=operand_right;
 tuple_index++;
}
void print_imc_code(void){
 int i=0;
 for(i=0;i<tuple_index;i++){
  printf("\n%s = %s %s %s",tuples[i].result,tuples[i].operand_left,tuples[i].operators,tuples[i].operand_right);
 }
 printf("\n");
}
int main(void){
 yyparse();
 return 0;
}
