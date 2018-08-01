%{
#include<stdlib.h>
#include<string.h>
#include "logic.h"
#include "y.tab.h"
extern void yyerror(char*);
extern char *token_string;
void tokenize(char*);
symtab *symbol_lookup(char*);
%}
letter [a-zA-Z]
digit [0-9]
string [-~]
id {letter}({letter}|{digit})*
%%
"+" {yylval.operator=strdup(yytext);tokenize(" + ");return CONCAT_1;}
"&" {yylval.operator=strdup(yytext);tokenize(" & "); return CONCAT_2;}
"=" {yylval.operator=strdup(yytext);tokenize(" = "); return ASSIGN;}
"(" {yylval.punctuation=strdup(yytext);tokenize(" ( ");return LEFT_P;}
")" {yylval.punctuation=strdup(yytext);tokenize(" ) ");return RIGHT_P;}
{id} {yylval.symp=symbol_lookup(yytext);tokenize("ID");return ID;}
{string} {yylval.constant=strdup(yytext);tokenize("STR");return STR;}
"$" exit(0);
[ \t] ;
\n|. return yytext[0];
%%
void tokenize(char *token){
 if(!token_string){
  token_string=strdup(token);
 }
 else{
  strcat(token_string,token);
 }
}
symtab *symbol_lookup(char *symbol){
 symtab *sp;
 for(sp=symbol_table;sp< &symbol_table[SIZE];sp++){
  if(sp->name && !strcmp(sp->name,symbol)){
    return sp;
  }
  if(!sp->name){
    sp->name=strdup(symbol);
    return sp;
  }
 }
}
