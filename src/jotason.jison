/* description: Jotason grammar with AST-building actions. */

/* author: Matias Olivera */

%token  TRUE
%token  FALSE
%token  NULL
%token  INFINITY
%token  NAN
%token  ID
%token  STRING
%token  NUMBER
%token  LBRACE
%token  RBRACE
%token  LBRACKET
%token  RBRACKET
%token  COMMA
%token  COLON
%token  ENDOFFILE

%start JotasonText

%%

JotasonNumber
    : NUMBER
        {{ $$ = $1; }}
    | INFINITY
        {{ $$ = $1; }}
    | NAN
        {{ $$ = $1; }}
    ;

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
        {{ $$ = {}; for (var i = 0; i < $1[0].length; i++) $$[$1[0][i]] = $1[1]; }}
    | JotasonMemberList COMMA JotasonMember
        {{ $$ = $1; for (var i = 0; i < $3[0].length; i++) $$[$3[0][i]] = $3[1]; }}
    ;

JotasonMember
    : JotasonKeyList COLON JotasonValue
        {{ $$ = [$1, $3]; }}
    ;

JotasonKeyList
    : JotasonKey
        {{ $$ = [$1]; }}
    | JotasonKeyList COMMA JotasonKey
        {{ $$ = $1; $$.push($3); }}
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
    | JotasonNumber
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

