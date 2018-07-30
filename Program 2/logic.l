%{
#include<stdlib.h>
#include<string.h>
#include "logic.h"
#include "y.tab.h"
extern void yyerror(char*);
extern char *token_string;
struct symtab *symbol_lookup(char*);
void tokenize(char*);
%}
letter [a-zA-Z]
digit [0-9]
id {letter}({letter}|{digit})*
num {digit}({digit})*
%%
{id} {yylval.symp=symbol_lookup(yytext); tokenize("ID"); return ID;}
{num} {yylval.number=strdup(yytext); tokenize("NUM"); return NUM;}
"+" {yylval.operator=strdup(yytext); tokenize(" + "); return ADD;}
"-" {yylval.operator=strdup(yytext); tokenize(" - "); return SUB;}
"*" {yylval.operator=strdup(yytext); tokenize(" * "); return MUL;}
"=" {yylval.operator=strdup(yytext); tokenize(" = "); return EQU;}
"(" {yylval.punctuation=strdup(yytext); tokenize(" ( "); return LEFT_P;}
")" {yylval.punctuation=strdup(yytext); tokenize(" ) "); return RIGHT_P;}
";" {yylval.punctuation=strdup(yytext); tokenize(" ; "); return SEMI_C;}
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
 for(sp=symbol_table;sp< &symbol_table[S_SIZE];sp++){
  if(sp->name && !strcmp(sp->name,symbol)){
   return sp;
  }
  if(!sp->name){
   sp->name=strdup(symbol);
   return sp;
  }
 }
 yyerror("Unable to find symbol!");
 exit(1); 
}
