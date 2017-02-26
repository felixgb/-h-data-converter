module Main where

import Control.Monad.Except

import System.Environment

import FParser
import FPrint
import FSyntax
import FEval

import Conv

main :: IO ()
main = do
    (flag : rest) <- getArgs
    case flag of
        "-fd" -> putStrLn (datafyProg $ parseProgram $ head rest)
        "-nl" -> putStrLn (conv $ head rest)
        "-e"  -> do
            source <- readFile (head rest)
            print source
            putStrLn (processProgram source (head $ tail rest))

processProgram :: String -> String -> String
processProgram prog inp = case runExcept evaled :: Either ConvError HTree of
    Right val -> show val
    Left err -> show err
    where
        evaled = do
            parsedData <- runTreeParser inp
            let parsedProgram = parseProgram prog
            runFProgram parsedData parsedProgram
