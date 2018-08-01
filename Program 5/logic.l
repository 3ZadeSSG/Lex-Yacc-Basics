%{
#include<stdlib.h>
#include<string.h>
#include "logic.h"
#include "y.tab.h"
extern void yyerror(char*);
extern char *token_string;
void tokenize(char*);
struct symtab *symbol_lookup(char*);
%}
letter [a-zA-Z]
digit [0-9]
id {letter}({letter}|{digit})*
num {digit}+|({digit}*\.{digit}+)([eE][-+]?{digit}+)?
%%
"=" {yylval.operator=strdup(yytext);tokenize(" = ");return ASSIGN;}
"*" {yylval.operator=strdup(yytext);tokenize(" * ");return MUL;}
"/" {yylval.operator=strdup(yytext);tokenize(" / ");return DIV;}
"(" {yylval.punctuation=strdup(yytext);tokenize(" ( ");return LEFT_P;}
")" {yylval.punctuation=strdup(yytext);tokenize(" ) ");return RIGHT_P;}
{num} {yylval.number=strdup(yytext);tokenize("NUM");return NUM;}
{id} {yylval.symp=symbol_lookup(yytext);tokenize("ID");return ID;}
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
struct symtab *symbol_lookup(char *symbol){
  struct symtab *sp;
  for(sp=symbol_table;sp< &symbol_table[SIZE];sp++){
   if(sp->name && !strcmp(sp->name,symbol)){
    return sp;
   }
   if(!sp->name){
    sp->name=strdup(symbol);
    return sp;
   }
  }
  yyerror("Cannot find the symbols!");
}
