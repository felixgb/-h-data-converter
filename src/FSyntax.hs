module FSyntax where

import Control.Monad.Except

data HTree = Nil | Node HTree HTree
    deriving (Eq, Ord)

instance Show HTree where
    show Nil = "nil"
    show (Node b1 b2) = "<" ++ show b1 ++ "." ++ show b2 ++ ">"

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

data Sem = Sem FExpr
    deriving (Eq, Ord, Show)

type FThrowsError = Except FError

data FError
    = FParseError
    deriving (Eq, Ord, Show)
