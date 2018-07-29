%{
#include <stdlib.h>
#include <string.h>
#include "logic.h"
#include "y.tab.h"
extern void yyerror(char*); //defintion in yacc file
extern char *token_string; //decleration in yacc file
void tokenize(char*);
struct symtab *symbol_lookup(char*);
%}
letter [a-zA-Z]
digit [0-9]
id {letter}({letter}|{digit})*
num {digit}({digit})*
%%
{id} {
 yylval.symp=symbol_lookup(yytext);
 tokenize("ID");
 return ID;
}
{num} {
 yylval.number=strdup(yytext);
 tokenize("NUM");
 return NUM;
}
"<" {
 yylval.operator=strdup(yytext);
 tokenize(" < ");
 return LESS_THAN;
}
">" {
 yylval.operator=strdup(yytext);
 tokenize(" > ");
 return GREATER_THAN;
}
"=" {
 yylval.operator=strdup(yytext);
 tokenize(" = ");
 return ASSIGN;
}
"!" {
 yylval.operator=strdup(yytext);
 tokenize(" ! ");
 return NOT_EQUAL;
}
"(" {
 yylval.punctuation=strdup(yytext);
 tokenize(" ( ");
 return LEFT_P;
}
")" {
 yylval.punctuation=strdup(yytext);
 tokenize(" ) ");
 return RIGHT_P;
}
"$" exit(0);
[ \t] ;
\n|. return yytext[0];
%%
void tokenize(char *token){
 if(!token_string){
  token_string=strdup(token); //in case token string is emoty
 }
 else{
  strcat(token_string,token);
 }
}
struct symtab *symbol_lookup(char *symbol){
 struct symtab *sp;
 for(sp=symbol_table;sp <&symbol_table[S_SIZE];sp++){
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
