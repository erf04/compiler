%{
#include "bison.tab.h"
#include <stdio.h>  // Include Bison header for token definitions
%}

letter          [A-Za-z]
id              {letter}({letter}|[0-9])*

%%

[0-9]+          { yylval.num = atoi(yytext);return NUMBER; } // Return NUMBER token
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MULTIPLY; }
"/"             { return DIVIDE; }
"("             { return LPAREN; }
")"             { return RPAREN; }
[ \t\n]+        { /* Ignore white spaces */ }
";"             { return END; }
"="             { return EQUAL; }
{id}            { yylval.str = strdup(yytext); return ID; }
.               { printf("Unknown character: %s\n", yytext); }
%%


int yywrap() {
    return 1; // Indicate no more input
}

