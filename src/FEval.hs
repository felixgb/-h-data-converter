module FEval where

import Control.Monad.Writer

import FSyntax

type FEval = WriterT [Sem] FThrowsError

evalFprog :: FProgram -> FEval HTree
evalFprog (FProgram var e b) = evalFExpr e b Nil
-- is var the inital input? hm

-- use reader for env?
evalFExpr :: FExpr -> FExpr -> HTree -> FEval HTree
evalFExpr e b var = case e of
    (FVar x) -> return var

    FNil -> return Nil

    (FCons e1 e2) -> do
        l <- evalFExpr e1 b var
        r <- evalFExpr e2 b var
        return $ Node l r

    (FHd e1) -> do
        r <- evalFExpr e1 b var
        return $ case r of
            (Node l r) -> l
            Nil -> Nil

    (FTl e1) -> do
        r <- evalFExpr e1 b var
        return $ case r of
            (Node l r) -> r
            Nil -> Nil

    (FApp e1) -> do
        
