module FPrint where

import qualified Data.List as L

import FSyntax

stringConcat = concat . (\l -> "[" : l ++ ["]"]) . L.intersperse ","

datafyProg :: FProgram -> String
datafyProg (FProgram x e b) = stringConcat [datafyExpr e, datafyExpr b]

datafyExpr :: FExpr -> String
datafyExpr expr = case expr of
    FVar                -> stringConcat ["@var"]
    FNil                -> stringConcat ["@quote", "@nil"]
    (FCons e1 e2)       -> stringConcat ["@cons", ts e1, ts e2]
    (FHd e1)            -> stringConcat ["@hd", ts e1]
    (FTl e1)            -> stringConcat ["@tl", ts e1]
    (FIf e1 e2 e3)      -> stringConcat ["@if", ts e1, ts e2, ts e3]
    (FApp e1)           -> stringConcat ["@appf", ts e1]
    where ts = datafyExpr
