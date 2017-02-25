module FSyntax where

data FProgram = FProgram String FExpr FExpr
    deriving (Eq, Ord, Show)

data FExpr
    = FVar String
    | FNil
    | FCons FExpr FExpr
    | FHd FExpr
    | FTl FExpr
    | FIf FExpr FExpr FExpr
    | FApp FExpr
    deriving (Eq, Ord, Show)
