module Conv where

import Control.Monad (void)
import Text.Megaparsec
import Text.Megaparsec.String
import qualified Text.Megaparsec.Lexer as L

data HTree = Nil | Node HTree HTree
    deriving (Eq, Ord)

instance Show HTree where
    show Nil = "nil"
    show (Node b1 b2) = "<" ++ show b1 ++ "." ++ show b2 ++ ">"

sc :: Parser ()
sc = L.space (void spaceChar) lineCmnt blockCmnt
  where 
    lineCmnt  = L.skipLineComment "//"
    blockCmnt = L.skipBlockComment "/*" "*/"

symbol :: String -> Parser String
symbol = L.symbol sc

lexeme :: Parser a -> Parser a
lexeme = L.lexeme sc

angles :: Parser a -> Parser a
angles = between (symbol "<") (symbol ">")

rword :: String -> Parser ()
rword w = string w *> notFollowedBy alphaNumChar *> sc

whileParser :: Parser HTree
whileParser = between sc eof tree

tree :: Parser HTree
tree = nil <|> node

nil :: Parser HTree
nil = rword "nil" >> return Nil

node :: Parser HTree
node = angles inner
    where
        inner = do
            l <- tree
            symbol "."
            r <- tree
            return $ Node l r
    
