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
%token  LPAREN
%token  RPAREN
%token  COMMA
%token  COLON
%token  ENDOFFILE

%start JotasonText

%%

JotasonNumber
    : NUMBER
        {
            $$ = $1;
        }
    | INFINITY
        {
            $$ = $1;
        }
    | NAN
        {
            $$ = $1;
        }
    ;

JotasonText
    : JotasonValue ENDOFFILE
        {
            typeof console !== 'undefined' ? console.log($1.toJson()) : print($1.toJson());
            return $$ = $1;
        }
    ;

JotasonObject
    : LBRACE RBRACE
        {
            $$ = new JotasonObject({});
        }
    | LBRACE JotasonMemberList RBRACE
        {
            $$ = new JotasonObject($2);
        }
    ;

JotasonMemberList
    : JotasonMember
        {
            members = {};
            for (var i = 0; i < $1[0].length; i++) {
                members[$1[0][i]] = $1[1];
            }
            $$ = members;
        }
    | JotasonMemberList COMMA JotasonMember
        {
            members = $1;
            for (var i = 0; i < $3[0].length; i++) {
                members[$3[0][i]] = $3[1];
            }
            $$ = members;
        }
    ;

JotasonMember
    : JotasonKeyList COLON JotasonValue
        {
            $$ = [$1, $3];
        }
    ;

JotasonKeyList
    : JotasonKey
        {
            $$ = [$1];
        }
    | JotasonKeyList COMMA JotasonKey
        {
            $$ = $1; $$.push($3);
        }
    ;

JotasonKey
    : STRING
        {
            $$ = $1;
        }
    | ID
        {
            $$ = $1;
        }
    | TRUE
        {
            $$ = $1;
        }
    | FALSE
        {
            $$ = $1;
        }
    | NULL
        {
            $$ = $1;
        }
    ;

JotasonArray
    : LBRACKET RBRACKET
        {
            $$ = new JotasonArray([]);
        }
    | LBRACKET JotasonElementList RBRACKET
        {
            $$ = new JotasonArray($2);
        }
    | LBRACKET LPAREN JotasonKeyList RPAREN COLON JotasonElementList RBRACKET
        {
            elements = [];
            var keyCount = $3.length, elementCount = $6.length;
            if (elementCount % keyCount == 0) {
                var rowCount = elementCount/keyCount;
                for (var i = 0; i < rowCount; i++) {
                    var members = {};
                    for (var j = 0; j < keyCount; j++) {
                        members[$3[j]] = $6[i*keyCount + j];
                    }
                    elements.push(new JotasonObject(members));
                }
                $$ = new JotasonArray(elements);
            } else {
                throw new SyntaxError("Element count should be multiple of key count");
            }
        }
    ;

JotasonElementList
    : JotasonValue
        {
            $$ = [$1];
        }
    | JotasonElementList COMMA JotasonValue
        {
            $$ = $1;
            $$.push($3);
        }
    ;

JotasonValue
    : STRING
        {
            $$ = new JotasonString(yytext);
        }
    | JotasonNumber
        {
            $$ = new JotasonNumber(Number(yytext));
        }
    | JotasonObject
        {
            $$ = $1;
        }
    | JotasonArray
        {
            $$ = $1;
        }
    | TRUE
        {
            $$ = new JotasonTruthValue(true);
        }
    | FALSE
        {
            $$ = new JotasonTruthValue(false);
        }
    | NULL
        {
            $$ = new JotasonNull();
        }
    ;

%%

/* AST nodes constructors */

function JotasonObject(members) {
    this.members = members;
    this.toJson = function() {
        var json = "{";
        var index = 0;
        for (var k in this.members) {
            if (this.members.hasOwnProperty(k)) {
                json += "\"" + k + "\": " + this.members[k].toJson();
                if (index < Object.keys(this.members).length - 1) json += ", ";
                index += 1;
            }
        }
        json += "}";
        return json;
    }
}

function JotasonArray(elements) {
    this.elements = elements;
    this.toJson = function() {
        var json = "[";
        this.elements.forEach(function(element, index, array) {
            json += element.toJson();
            if (index < array.length - 1) json += ", ";
        });
        json += "]";
        return json;
    }
}

function JotasonString(value) {
    this.value = value;
    this.toJson = function() {
        return "\"" + this.value + "\"";
    }
}

function JotasonNumber(value) {
    this.value = value;
    this.toJson = function() {
        return this.value;
    }
}

function JotasonTruthValue(value) {
    this.value = value;
    this.toJson = function() {
        return this.value;
    }
}

function JotasonNull() {
    this.value = null;
    this.toJson = function() {
        return "null";
    }
}
