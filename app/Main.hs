module Main where

import System.Environment

import FParser
import FPrint

main :: IO ()
main = do
    args <- getArgs
    case head args of
        "-fd" -> putStrLn (datafyProg $ parseProgram $ head $ tail args)
