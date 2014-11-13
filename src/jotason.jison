/* description: Jotason grammar with AST-building actions. */

/* author: Matias Olivera */

%token  ID
%token  STRING
%token  NUMBER
%token  LBRACE
%token  RBRACE
%token  LBRACKET
%token  RBRACKET
%token  COMMA
%token  COLON
%token  TRUE
%token  FALSE
%token  NULL
%token  ENDOFFILE

%start JotasonText

%%

JotasonText
    : JotasonValue ENDOFFILE
        {{ typeof console !== 'undefined' ? console.log($1) : print($1); return $$ = $1; }}
    ;

JotasonObject
    : LBRACE RBRACE
        {{ $$ = {}; }}
    | LBRACE JotasonMemberList RBRACE
        {{ $$ = $2; }}
    ;

JotasonMemberList
    : JotasonMember
        {{ $$ = {}; $$[$1[0]] = $1[1]; }}
    | JotasonMemberList COMMA JotasonMember
        {{ $$ = $1; $$[$3[0]] = $3[1]; }}
    ;

JotasonMember
    : JotasonKey COLON JotasonValue
        {{ $$ = [$1, $3]; }}
    ;

JotasonKey
    : STRING
        {{ $$ = $1; }}
    | ID
        {{ $$ = $1; }}
    | TRUE 
        {{ $$ = $1; }}
    | FALSE
        {{ $$ = $1; }}
    | NULL
        {{ $$ = $1; }}
    ;

JotasonArray
    : LBRACKET RBRACKET
        {{ $$ = []; }}
    | LBRACKET JotasonElementList RBRACKET
        {{ $$ = $2; }}
    ;

JotasonElementList
    : JotasonValue
        {{ $$ = [$1];}}
    | JotasonElementList COMMA JotasonValue
        {{ $$ = $1; $$.push($3); }}
    ;

JotasonValue
    : STRING
        {{ $$ = yytext; }}
    | NUMBER
        {{ $$ = Number(yytext); }}
    | JotasonObject
        {{ $$ = $1; }}
    | JotasonArray
        {{ $$ = $1; }}
    | TRUE
        {{ $$ = true; }}
    | FALSE
        {{ $$ = false; }}
    | NULL
        {{ $$ = null; }}
    ;

