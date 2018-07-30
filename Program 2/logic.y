%{
#include<stdlib.h>
#include<string.h>
#include<stdio.h>
#include "logic.h"
extern struct symtab *symbol_lookup(char*);
int yylex();
void yyerror(char*);
void print_3_IMC();
void generate_3_IMC(char*,char*,char*,char*);
char *new_temp();
char *token_string=NULL;
int t_index=0;
int temp_index=0;
%}
%union{
 char *number;
 char *operator;
 char *punctuation;
 struct symtab *symp;
}
%token <number> NUM
%token <operator> ADD SUB MUL EQU
%token <punctuation> LEFT_P RIGHT_P SEMI_C
%token <symp> ID
%left ADD MUL
%type <number> E T F
%%
SL: S '\n' { 
 printf("Tokenized : %s\n",token_string);
 print_3_IMC();
}
| SL S '\n' {
 printf("Tokenized : %s\n",token_string);
 print_3_IMC();
}
;
S: ID EQU E {generate_3_IMC($1->name,$3,"",""); $1->value=$3;}
| E
;
E: E ADD T {$$=new_temp();generate_3_IMC($$,$1," + ",$3);}
| T
;
T: T MUL F {$$=new_temp();generate_3_IMC($$,$1," * ",$3);}
| F
F: LEFT_P E RIGHT_P {strcpy($$,$2);}
| SUB LEFT_P E RIGHT_P {strcpy($$,"-");strcat($$,$3);}
| ID {$$=$1->name;}
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
  printf("\t%s =",tuples[i].result);
  printf("%s ",tuples[i].operand_left);
  printf("%s ",tuples[i].operators);
  printf("%s \n",tuples[i].operand_right);
 }
 token_string=NULL;
 t_index=0;
 temp_index=0;
}
void generate_3_IMC(char *result,char *operand_left,char *operators,char *operand_right){
  tuples[t_index].result=result;
  tuples[t_index].operators=operators;
  tuples[t_index].operand_left=operand_left;
  tuples[t_index++].operand_right=operand_right;
}
int main(int *argc,char **argv){
 yyparse();
 return 0;
}






