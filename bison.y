%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Function to reverse a number
int reverse_number(int num) {
    int reversed = 0;
    while (num != 0) {
        reversed = reversed * 10 + num % 10;
        num /= 10;
    }
    return reversed;
}

int reverse(int num){
    int reversed = num;
    if (num % 10 != 0) {
        reversed = reverse_number(num);
        printf("Reversed NUMBER: %d -> %d\n", num, reversed);
        return reversed;
    } else {
        printf("reserved number %d -> %d \n",num,reversed);
        return reversed;
    }
}

int temp_counter = 1;
char* new_temp() {
    char* temp = (char*)malloc(10);
    sprintf(temp, "t%d", temp_counter++);
    return temp;
}

int yylex();
int yyerror(const char *s);

%}

%union {
    int num;
    char* str;
}

%token <str> ID
%token <num> NUMBER

%token END EQUAL

%token PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN

%type <num> e expr t f


%left MULTIPLY DIVIDE // Left associative for multiplication and division
%right PLUS MINUS     // Right associative for addition and subtraction

%start e

%%


e : ID EQUAL expr END{
    $$ = $3;
    printf("final result %s = %d \n", $1,$$);
    return 0;
}

expr 
    :expr MULTIPLY t {
        $$ = reverse($1 * $3);
        printf("Computed %d * %d = %d \n",$1,$3,$$);
        // printf("t%d = %d * %d \n",t++,$1,$3);
    } 
    | expr DIVIDE t{
        $$ = reverse($1 / $3);
        printf("Computed %d / %d = %d \n",$1,$3,$$);
        // printf("t%d = %d / %d \n",t++,$1,$3);
    }
    | t {
        $$ = $1;
        printf("Computed %d \n",$1);
    }


t 
    : f PLUS t{
        $$ = reverse($1 + $3); // Right associative
        // printf("t%d = %d + %d \n",t++,$1,$3);
        printf("Computed %d + %d = %d \n",$1,$3,$$);
    } 
    | f MINUS t {
        $$ = reverse($1 - $3); // Right associative
        // printf("t%d = %d - %d \n",t++,$1,$3);
        printf("Computed %d - %d = %d \n",$1,$3,$$);
    }
    | f {
        $$ = $1;
    }


f 
    : LPAREN expr RPAREN {
        $$ = $2;
    }
    | NUMBER{
        $$ = reverse($1);
    }


%%

int main() {
    printf("Enter an expression: ");
    yyparse();
    return 0;
}

int yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 1;
}
