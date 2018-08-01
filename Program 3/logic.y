%{
#include<stdio.h>
#include<stdlib.h>
#include <string.h>
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
 char *punctuation;
 char *operator;
 char *constant;
 struct symtab *symp;
}
%token <punctuation> LEFT_P RIGHT_P
%token <operator> CONCAT_1 CONCAT_2 ASSIGN
%token <constant> STR
%token <symp> STR
%%
%%
void yyerror(char *s){
 fprintf(stderr,"%s\n",s);
}
void print_3_IMC(){
 int i=0;
 for(i=0;i<t_index;i++){
  printf("%s = ",tuples[i].result);
  printf("%s ",tuples[i].operand_left);
  printf("%s ",tuples[i].operators);
  printf("%s ",tuples[i].operand_right);  
 }
}









