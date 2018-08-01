%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "logic.h"
extern symtab *symbol_lookup(char*);
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
 char *punctuation;
 char *operator;
 char *constant;
 symtab *symp;
}
%token <punctuation> LEFT_P RIGHT_P
%token <operator> CONCAT_1 CONCAT_2 ASSIGN
%token <constant> STR
%token <symp> ID
%type <constant> E T F
%%
SL: S '\n' { print_3_IMC();}
| SL S '\n' {print_3_IMC();}
;
S: ID ASSIGN E {
 generate_3_IMC($1->name,$3,"","");
 $1->value=$3;
}
| E
;
E: E CONCAT_1 T {
 $$=new_temp();
 generate_3_IMC($$,$1," + ",$3);
}
| T
;
T: T CONCAT_2 F {
 $$=new_temp();
 generate_3_IMC($$,$1," + ",$3); //should be '&' but in problem statement '+' is used
}
| F
;
F: LEFT_P E RIGHT_P {
 strcpy($$,$2);
}
| ID {
 $$=$1->name;
}
| STR
;
%%
void yyerror(char *s){
 fprintf(stderr,"%s\n",s);
}
void print_3_IMC(){
 printf("Tokenized string: %s\n",token_string);
 int i=0;
 for(i=0;i<t_index;i++){
  printf("%s = ",tuples[i].result);
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
 tuples[t_index].operand_left=operand_left;
 tuples[t_index].operand_right=operand_right;
 tuples[t_index++].operators=operators;
}
char *new_temp(){
 char *temp=(char*)malloc(sizeof(char)*50);
 sprintf(temp,"t%d",++temp_index);
 return temp;
}
int main(void){
 yyparse();
 return 0;
}
