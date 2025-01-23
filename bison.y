%{
#define YYDEBUG 1
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// #include "attr.h"

struct Attr{
    char* str;
    int num;
} ;

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
        // printf("Reversed NUMBER: %d -> %d\n", num, reversed);
        return reversed;
    } else {
        // printf("reversed number %d -> %d \n",num,reversed);
        return reversed;
    }
}

int temp_counter = 1;
char* new_temp() {
    char* temp = (char*)malloc(10);
    sprintf(temp, "t%d", temp_counter++);
    return temp;
}

char* int_to_string(int num) {
    // Allocate enough memory to store the string representation
    // Maximum digits for an int + 1 for the sign + 1 for '\0'
    char* str = (char*)malloc(12 * sizeof(char));  
    if (str == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(1);
    }

    // Convert the integer to a string
    sprintf(str, "%d", num);

    return str; // Return the allocated string
}

int yylex();
int yyerror(const char *s);

%}

%debug

%union {
    int num;
    char* str;
    struct Attr* attr;
}

%token <str> ID
%token <num> NUMBER

%token END EQUAL

%token PLUS MINUS MULTIPLY DIVIDE LPAREN RPAREN

%type <attr> e expr t f


%left MULTIPLY DIVIDE // Left associative for multiplication and division
%right PLUS MINUS     // Right associative for addition and subtraction

%start e

%%


e : ID EQUAL expr END{
    // $$ = malloc(sizeof(struct Attr));
    // $$->str = $3->str;
    // $$->num = $3->num;
    printf("%s = %s;\n", $1, $3->str); // Assign the last temp variable to the ID
    // printf("mmd");
    printf("final value : %d ",$3->num);
    return 0;
};

expr 
    :expr MULTIPLY t {
        // $$ = reverse($1 * $3);
        // printf("Computed %d * %d = %d \n",$1,$3,$$);
        char* temp = new_temp();
        printf("%s = %s * %s;\n", temp, $1->str, $3->str); // TAC for multiplication
        $$ = malloc(sizeof(struct Attr));
        $$->str = temp;
        $$->num = reverse($1->num * $3->num);

    } 
    | expr DIVIDE t{
        // $$ = reverse($1 / $3);
        // printf("Computed %d / %d = %d \n",$1,$3,$$);
        char* temp = new_temp();
        printf("%s = %s / %s;\n", temp, $1->str, $3->str); // TAC for division
        $$ = malloc(sizeof(struct Attr));
        $$->str = temp;
        $$->num = reverse($1->num / $3->num);

    }
    | t {
        $$ = malloc(sizeof(struct Attr));
        $$ = $1;
        // printf("Computed %d \n",$1);
    }


t 
    : f PLUS t{
        // $$ = reverse($1 + $3); // Right associative
        // // printf("t%d = %d + %d \n",t++,$1,$3);
        // printf("Computed %d + %d = %d \n",$1,$3,$$);
        char* temp = new_temp();
        printf("%s = %s + %s;\n", temp, $1->str, $3->str); // TAC for addition
        $$ = malloc(sizeof(struct Attr));
        $$->str = temp;
        $$->num = reverse($1->num + $3->num);

    } 
    | f MINUS t {
        char* temp = new_temp();
        printf("%s = %s - %s;\n", temp, $1->str, $3->str); // TAC for subtraction
        // printf("Computed %d - %d = %d \n",$1,$3,$$);
        $$ = malloc(sizeof(struct Attr));
        $$->str = temp;
        $$->num = reverse($1->num - $3->num);

    }
    | f {
        // printf("Computed %d \n",$1->num);
        $$ = malloc(sizeof(struct Attr));
        $$ = $1;
    }


f 
    : LPAREN expr RPAREN {
        $$ = malloc(sizeof(struct Attr));
        $$ = $2;
    }
    | NUMBER{
        // char* temp = new_temp();
        int reversed = reverse($1);
        // $$ = reverse($1);
        // $$->str = int_to_string(reversed);
        $$ = malloc(sizeof(struct Attr));
        $$->str = int_to_string(reversed);
        $$->num = reversed;
        // printf("Computed %s , %d \n",$$->str,$$->num);
    }


%%

int main() {
    // yydebug = 1; // Enable debug mode

    printf("Enter an expression: ");
    yyparse();
    return 0;
}

int yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 1;
}
