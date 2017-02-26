{
module FParser where

import FLexer
import FSyntax
}

%name parseP Prog
%name parseE Expr
%tokentype { Token }
%error { parseError }

%token
    input              { TkInput }
    output             { TkOutput }
    where              { TkWhere }
    f                  { TkApp }
    nil                { TkNil }
    cons               { TkCons }
    hd                 { TkHd }
    tl                 { TkTl }
    if                 { TkIf }
    then               { TkThen }
    else               { TkElse }
    var                { TkVar $$ }
    '('                { TkLParen }
    ')'                { TkRParen }
    '='                { TkEq }

%%

Prog :: { FProgram }
Prog : input var output Expr where f '(' var ')' '=' Expr       { FProgram $2 $4 $11 }

Expr :: { FExpr }
Expr : var                              { FVar }
     | nil                              { FNil }
     | cons Expr Expr                   { FCons $2 $3 }
     | hd Expr                          { FHd $2 }
     | tl Expr                          { FTl $2 }
     | if Expr then Expr else Expr      { FIf $2 $4 $6 }
     | f '(' Expr ')'                   { FApp $3 }

{
parseError = error . show

parseProgram :: String -> FProgram
parseProgram = parseP . scan

parseExpr :: String -> FExpr
parseExpr = parseE . scan
}
