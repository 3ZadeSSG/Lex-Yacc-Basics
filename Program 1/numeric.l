%{
	#include "numeric.h"
	#include "y.tab.h"
	#include <string.h>
	#include<stdlib.h>
	struct symtab *symbol_lookup(char *);
	void tokenizer(char *);
	extern void yyerror(char *);
	extern char *token_string;
%}
letter [a-zA-Z]
digit [0-9]
id {letter}({letter}|{digit})*
num {digit}+|({digit}*\.{digit}+)([eE][-+]?{digit}+)?
%%

{num} {yylval.number=strdup(yytext);tokenize("NUM");return NUM;}
{id} {yylval.symp=symbol_lookup(yytext);tokenize("ID");return ID;}

"+" {yylval.operator=yytext[0];tokenize(" + ");return ADD;}
"-" {yylval.operator=yytext[0];tokenize(" - ");return SUB;}
"*" {yylval.operator=yytext[0];tokenize(" * ");return MUL;}
"/" {yylval.operator=yytext[0];tokenize(" / ");return DIV;}
"(" {yylval.parenthesis=yytext[0];tokenize(" ( ");return LEFT_P;}
")" {yylval.parenthesis=yytext[0];tokenize(" ) ");return RIGHT_P;}
"=" {yylval.operator=yytext[0];tokenize(" () ");return ASSIGN;}
"$" {exit(0);}
[ \t] {;}
\n|. {return yytext[0];}
%%
struct symtab *symbol_lookup(char *symbol){
	struct symtab *sp;
	for(sp=symbol_table ;s<&symbol_table[NSYS];sp++){
		if(sp->name && !strcmp(sp->name,symbol))
			return sp;
		if(!sp->name){
			sp->name=strcup(symbol);
			return sp;
		}
	}
	yyerror("Cannot find Symbol, exceeded!");
	exit(1);
}

void tokenize(char *token){
	if(!token_string){
		token_string=strdup(token);
	}
	else{
		char *temp;
		temp=(char*)malloc((sizeof(char)*(strlen(token)+strlen(token_string)))+1);
		strcpy(temp,token_string);
		strcat(temp,token);
		token_string=strdup(temp);
		free(temp)
	}
}
