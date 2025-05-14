%{
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

extern int yyparse();
void yyerror(const char *s);
%}

%option noinput
%option nounput
%option noyywrap

digit   [0-9]
alpha   [a-zA-Z]

%%

"set_karo"          { return SET_KARO; }
"kar_jab_tak"       { return KAR_JAB_TAK; }
"jab_tak"           { return JAB_TAK; }
"likho"             { return LIKHO; }
"="                 { return ASSIGN; }
";"                 { return SEMICOLON; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
"{"                 { return LBRACE; }
"}"                 { return RBRACE; }
"+"                 { return PLUS; }
"-"                 { return MINUS; }
"*"                 { return MUL; }
"/"                 { return DIV; }
"<"                 { return LT; }

{digit}+            {
    yylval.num = atoi(yytext);
    return NUMBER;
}

{alpha}({alpha}|{digit})* {
    yylval.str = strdup(yytext);
    return IDENT;
}

[ \t\n]             ; // Skip whitespace
.                   { yyerror("Invalid character"); }
%%
