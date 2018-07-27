%{
#include<stdlib.h>
#include<string.h>
#include "numeric.h"
#include "y.tab.h"
extern void yyerror(char*);
extern char *token_string;
void tokenize(char*);
struct symtab *symbol_lookup(char*);
%}
letter [a-zA-Z]
digit [0-9]
id {letter}({letter}|{digit})*
num {digit}+|({digit}*\.{digit}+)([eE][-+]?{digit}?)
%%
{num} {
 yylval.number=strdup(yytext);
 tokenize("NUM");
 return NUM;
}
{id} {
 yylval.symp=symbol_lookup(yytext);
 tokenize("ID");
 return ID;
}
"+" {
 yylval.operator=yytext[0];
 tokenize(" + ");
 return ADD;
}
"-" {
 yylval.operator=yytext[0];
 tokenize(" - ");
 return SUB;
}
"*" {
 yylval.operator=yytext[0];
 tokenize(" * ");
 return MUL; 
}
"/" {
 yylval.operator=yytext[0];
 tokenize(" / ");
 return DIV;
}
"=" {
 yylval.operator=yytext[0];
 tokenize(" = ");
 return ASSIGN;
}
"(" {
 yylval.parenthesis=yytext[0];
 tokenize(" ( ");
 return LEFT_P;
}
")" {
 yylval.parenthesis=yytext[0];
 tokenize(" ) ");
 return RIGHT_P;
}
"$" exit(0);
[ \t] ;
\n|. return *yytext;
%%
void tokenize(char *token){
 if(!token_string){
  token_string=strdup(token);
 } 
 else{
  char *temp;
  temp=(char*)malloc(strlen(token)+strlen(token_string)+1);
  strcpy(temp,token_string);
  strcat(temp,token);
  strcpy(token_string,temp);
  free(temp);
 }
}
struct symtab *symbol_lookup(char *symbol){
  struct symtab *sp;
  for(sp=symbol_table;sp<&symbol_table[NSYS];sp++){
   if(!sp->name && strcmp(sp->name,symbol)){
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





















