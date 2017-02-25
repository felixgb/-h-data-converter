module Main where

import System.Environment

import FParser
import FPrint

import Conv

main :: IO ()
main = do
    (flag : expr) <- getArgs
    case flag of
        "-fd" -> putStrLn (datafyProg $ parseProgram $ head expr)
        "-nl" -> putStrLn (conv $ head expr)
