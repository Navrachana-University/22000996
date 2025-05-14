%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int temp_counter = 0;
int loop_depth = 0;

char* create_temp() {
    static char temp[10];
    snprintf(temp, sizeof(temp), "t%d", temp_counter++);
    return strdup(temp); // Use strdup to prevent reuse
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
%}

%union {
    int num;
    char* str;
}

%token <num> NUMBER
%token <str> IDENT
%token SET_KARO KAR_JAB_TAK JAB_TAK LIKHO
%token ASSIGN SEMICOLON LPAREN RPAREN LBRACE RBRACE
%token PLUS MINUS MUL DIV LT

%type <str> expr condition

%%

program:
    statements
    ;

statements:
    statements statement
    | statement
    ;

statement:
    SET_KARO IDENT ASSIGN expr SEMICOLON  {
        printf("%s = %s\n", $2, $4);
    }
    | LIKHO LPAREN IDENT RPAREN SEMICOLON {
        printf("print %s\n", $3);
    }
    | KAR_JAB_TAK LBRACE {
        printf("L%d:\n", loop_depth); // Loop start label
    } statements RBRACE JAB_TAK LPAREN condition RPAREN SEMICOLON {
        printf("if (%s) goto L%d\n", $8, loop_depth); // If condition true, repeat loop
        loop_depth++;
    }
    ;

condition:
    expr LT expr {
        char* temp = create_temp();
        printf("%s = %s < %s\n", temp, $1, $3);
        $$ = temp;
    }
    ;

expr:
    expr PLUS expr {
        char* temp = create_temp();
        printf("%s = %s + %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr MINUS expr {
        char* temp = create_temp();
        printf("%s = %s - %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr MUL expr {
        char* temp = create_temp();
        printf("%s = %s * %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr DIV expr {
        char* temp = create_temp();
        printf("%s = %s / %s\n", temp, $1, $3);
        $$ = temp;
    }
    | NUMBER {
        char* temp = create_temp();
        printf("%s = %d\n", temp, $1);
        $$ = temp;
    }
    | IDENT {
        $$ = strdup($1); // Return the identifier directly
    }
    ;

%%
