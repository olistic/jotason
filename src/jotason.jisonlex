int                         \-?(?:[0-9]|[1-9][0-9]+)
exp                         (?:[eE][-+]?[0-9]+)
frac                        (?:\.[0-9]+)
string                      \"(?:[^\"\\]|\\[\"bfnrt/\\]|\\\u[a-fA-F0-9]{4})*\"

%%
\s+                         { /* skip whitespace */ }
{int}{frac}?{exp}?\b        { return 'NUMBER'; }
{string}                    { yytext = yytext.substr(1, yyleng - 2); return 'STRING'; }
"{"                         { return 'LBRACE'; }
"}"                         { return 'RBRACE'; }
"["                         { return 'LBRACKET'; }
"]"                         { return 'RBRACKET'; }
":"                         { return 'COLON'; }
","                         { return 'COMMA'; }
true\b                      { return 'TRUE'; }
false\b                     { return 'FALSE'; }
null\b                      { return 'NULL'; }
<<EOF>>                     { return 'ENDOFFILE'; }

