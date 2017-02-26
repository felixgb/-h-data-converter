module FEval where

import Control.Monad.Writer
import Control.Monad.Reader
import Control.Monad.Except

import FSyntax

evalFProg :: FProgram -> FEval HTree
evalFProg (FProgram var e b) = evalFExpr e b
-- is var the inital input? hm

type FEval = ReaderT HTree ThrowsError

runFProgram :: HTree -> FProgram -> ThrowsError HTree
runFProgram inp prog = runReaderT (evalFProg prog) inp

-- use reader for env?
evalFExpr :: FExpr -> FExpr -> FEval HTree
evalFExpr e b = case e of
    FVar -> ask

    FNil -> return Nil

    (FCons e1 e2) -> do
        l <- evalFExpr e1 b
        r <- evalFExpr e2 b
        return $ Node l r

    (FHd e1) -> do
        r <- evalFExpr e1 b
        return $ case r of
            (Node l r) -> l
            Nil -> Nil

    (FTl e1) -> do
        r <- evalFExpr e1 b
        return $ case r of
            (Node l r) -> r
            Nil -> Nil

    (FApp e1) -> do
        res <- evalFExpr e1 b
        local (\_ -> res) (evalFExpr b b)

    (FIf cond tr fl) -> do
        res <- evalFExpr cond b
        if res /= Nil then evalFExpr tr b else evalFExpr fl b
        
