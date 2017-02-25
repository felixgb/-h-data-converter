{
module FLexer
    ( Token (..)
    , scan
    ) where
}

%wrapper "basic"

$alpha = [a-zA-Z]

tokens :-
    $white+             ;
    "--".*              ;
    "input"             { \s -> TkInput }
    "output"            { \s -> TkOutput }
    "where"             { \s -> TkWhere }
    "f"                 { \s -> TkApp }
    "nil"               { \s -> TkNil }
    "cons"              { \s -> TkCons }
    "hd"                { \s -> TkHd }
    "tl"                { \s -> TkTl }
    "if"                { \s -> TkIf }
    "then"              { \s -> TkThen }
    "else"              { \s -> TkElse }
    [$alpha]+           { \s -> TkVar s }
    \(                  { \s -> TkLParen }
    \)                  { \s -> TkRParen }
    \=                  { \s -> TkEq }

{

data Token
    = TkInput
    | TkOutput
    | TkVar String
    | TkWhere
    | TkApp
    | TkLParen
    | TkRParen
    | TkEq
    | TkNil
    | TkCons
    | TkHd
    | TkTl
    | TkIf
    | TkThen
    | TkElse
    deriving (Eq, Show)

scan = alexScanTokens

}
