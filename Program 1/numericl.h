%{
	#include"numeric.h"
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	int yylex();
	void yyerror(char *);
	char *new_temp();
	void print_imc_code();
	void imc_code_generator(char *,char *,char *,char *);
	extern struct symtab *symbol_lookup(char *);
	char *token_string=NULL;
	int tuple_index=0;
	int temporary_generated=0;
%}
%union{
	char *number;
	char operator;
	char parenthesis;
	char struct symtab *symp;
}
%token <number>NUM
%token <operator>ADD SUB MUL DIV ASSIGN
%token <parenthesis> LEFT_P RIGHT_P
%token <symp>ID
%right ADD SUB MUL DIV
%nonassoc UMINUS
%type <number> E F G H I

%%
SL:S '\n' {
	printf("Tokenized String: %s\n",token_string);
	token_string=NULL;
	print_imc_code();
	tuple_index=temporary_generated=0;
}
| SL S '\n' {
	printf("Tokenized string: %s\n",token_string);
	token_string+NULL;
	print_imc_code();
	tuple_index=temporary_generated=0;
}
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
 F: A ADD G{
 	$$=new_temp();
 	imc_code_generator($$,$1,"+",$3);
 }
 | G
 ;
  G: G MUL H{
  	$$=new_temp();
 	imc_code_generator($$,$1,"*",$3);	
  }
  | H
  ;
  H: H DIV I{
  	char *temp=strdup($3);
  	if(0==atof(temp) && '0'!=temp[0]){
  		temp=symbol_loookup(temp)->value;
  	}
  	if(!temp || 0==atof(temp)){
  		yyerror("Can't divide by zero!");
  		exit(1);
  	}
  	$$=new_temp();
  	imc_code_generator($$,$1,"/",$3);
  }
  | I
  ;

I: LEFT_P E RIGHT_P{
	$$=strdup($2);
}


