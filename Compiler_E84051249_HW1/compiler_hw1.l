/* Definition section */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #define YY_NO_UNPUT
    #define YY_NO_INPUT

    int line_num = 0;
    int comment_num = 0;
    int last_comment_line_num=-1;
%}

/* Define regular expression label */
letter [a-zA-Z_]
digit [0-9]
id {letter}+({letter}|{digit})*
inumber {digit}+
fnumber ({digit}*\.{digit}+)
str \"(letter|digit)*\"
everythingExceptCL  .*
cppStyleCom \/{2}.*
CStyleComment "/*"([^*]|\*+[^/])*\*+"/"
quo ["]
changeLine [\n]
cSCom1 "/*"
cSCom2 "*/"

%START cSCom inStr Str 
/* Rules section */
%%




{CStyleComment}   {
    int start=0;
    for(int i=0;i<yyleng;i++)
    {
        
        if(i==0)
        {
            if(line_num!=last_comment_line_num){comment_num++;last_comment_line_num=line_num; printf("%s", "/*"); }
            else{printf("%s", "/*");}
            start=2;
        }
        if((yytext[i]=='*')&&(yytext[i+1]=='/'))
        {
            if(line_num!=last_comment_line_num){comment_num++;last_comment_line_num=line_num;}
            for(int j=start;j<=i+1;j++)
            {
                printf("%c",yytext[j]);
            }
            printf("%-6s \t %s\n","", "C Comment");
        }
        else if(yytext[i]=='\n')
        {
            line_num++;
            if(line_num!=last_comment_line_num){comment_num++;last_comment_line_num=line_num;}
            for(int j=start;j<=i;j++)
            {
                printf("%c",yytext[j]);
            }
            printf("%-7s \t %s\n","", "C Comment");
            start=i+1;
        }
    }
}
{cSCom2}    { }

"+"         { printf("%-8s \t %s\n", yytext, "ADD"); }
"-"         { printf("%-8s \t %s\n", yytext, "SUB"); }
"*"         { printf("%-8s \t %s\n", yytext, "MUL"); }
"/"         { printf("%-8s \t %s\n", yytext, "QUO"); }
"%"         { printf("%-8s \t %s\n", yytext, "REM"); }
"++"        { printf("%-8s \t %s\n", yytext, "INC"); }
"--"        { printf("%-8s \t %s\n", yytext, "DEC"); }
">"         { printf("%-8s \t %s\n", yytext, "GTR"); }
"<"         { printf("%-8s \t %s\n", yytext, "LSS"); }
">="        { printf("%-8s \t %s\n", yytext, "GEQ"); }
"<="        { printf("%-8s \t %s\n", yytext, "LEQ"); }
"=="        { printf("%-8s \t %s\n", yytext, "EQL"); }
"!="        { printf("%-8s \t %s\n", yytext, "NEQ"); }
"="         { printf("%-8s \t %s\n", yytext, "ASSIGN"); }
"+="        { printf("%-8s \t %s\n", yytext, "ADD_ASSIGN"); }
"-="        { printf("%-8s \t %s\n", yytext, "SUB_ASSIGN"); }
"*="        { printf("%-8s \t %s\n", yytext, "MUL_ASSIGN"); }
"/="        { printf("%-8s \t %s\n", yytext, "QUO_ASSIGN"); }
"%="        { printf("%-8s \t %s\n", yytext, "REM_ASSIGN"); }
"&&"        { printf("%-8s \t %s\n", yytext, "LAND"); }
"||"        { printf("%-8s \t %s\n", yytext, "LOR"); }
"!"         { printf("%-8s \t %s\n", yytext, "NOT"); }
"("         { printf("%-8s \t %s\n", yytext, "LPAREN"); }
")"         { printf("%-8s \t %s\n", yytext, "RPAREN"); }
"["         { printf("%-8s \t %s\n", yytext, "LBRACK"); }
"]"         { printf("%-8s \t %s\n", yytext, "RBRACK"); }
"{"         { printf("%-8s \t %s\n", yytext, "LBRACE"); }
"}"         { printf("%-8s \t %s\n", yytext, "RBRACE"); }
";"         { printf("%-8s \t %s\n", yytext, "SEMICOLON"); }
","         { printf("%-8s \t %s\n", yytext, "COMMA"); }


"string"    { printf("%-8s \t %s\n", yytext, "STRING"); BEGIN Str;}
<Str>{quo}  { printf("%-8s \t %s\n", yytext, "QUOTA"); BEGIN inStr;}
<inStr>{quo}  { printf("%-8s \t %s\n", yytext, "QUOTA"); BEGIN 0;}
"\n"        { printf("%-8s \t NEWLINE\n","");line_num++ ;BEGIN 0;}

"\""        { printf("%-8s \t %s\n", yytext, "QUOTA");}

"print"     { printf("%-8s \t %s\n", yytext, "PRINT"); }
"println"   { printf("%-8s \t %s\n", yytext, "PRINTLN");BEGIN Str; }
"if"        { printf("%-8s \t %s\n", yytext, "IF"); }
"else"      { printf("%-8s \t %s\n", yytext, "ELSE"); }
"for"       { printf("%-8s \t %s\n", yytext, "FOR"); }
"int32"     { printf("%-8s \t %s\n", yytext, "INT"); }
"float32"   { printf("%-8s \t %s\n", yytext, "FLOAT"); }


"bool"      { printf("%-8s \t %s\n", yytext, "BOOL"); }

"true"      { printf("%-8s \t %s\n", yytext, "TRUE"); }
"false"     { printf("%-8s \t %s\n", yytext, "FALSE"); }
"var"       { printf("%-8s \t %s\n", yytext, "VAR"); }

{inumber}   { printf("%-8s \t %s\n", yytext, "INT_LIT"); }
{fnumber} { printf("%-8s \t %s\n", yytext, "FLOAT_LIT"); }

<inStr>{id}    { printf("%-8s \t %s\n", yytext, "STRING"); BEGIN 0;}

{cppStyleCom}   { printf("%-8s \t %s\n", yytext, "C++ Comment"); if(last_comment_line_num!=line_num){comment_num++;last_comment_line_num=line_num;}}



{id}        { printf("%-8s \t %s\n", yytext, "IDENT"); }

<<EOF>>     { line_num++; yyterminate(); }
.           {;}

%%

/*  C Code section */
int yywrap(void)
{
    return 1;
}

int main(int argc, char *argv[])
{
    if (argc == 2) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }
    yylex();
    printf("\nFinish scanning,\n");
    printf("total line: %d\n", line_num);
    printf("comment line: %d\n", comment_num);
    fclose(yyin);
    return 0;
}
