module Conv where

import Control.Monad (void)
import Control.Monad.Except
import Text.Megaparsec
import Text.Megaparsec.String
import Text.Megaparsec.Error
import qualified Text.Megaparsec.Lexer as L

data HTree = Nil | Node HTree HTree
    deriving (Eq, Ord)

instance Show HTree where
    show Nil = "nil"
    show (Node b1 b2) = "<" ++ show b1 ++ "." ++ show b2 ++ ">"

-- parser

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

-- converter

type ThrowsError = Except ConvError

data ConvError
    = NumError HTree
    | TreeParseError String
    deriving (Eq, Ord, Show)

runTreeParser :: String -> ThrowsError HTree
runTreeParser inp = case runParser tree "<stdin>" inp of
    (Left err) -> throwError $ TreeParseError (parseErrorPretty err)
    (Right val) -> return val

convertToNumList :: String -> ThrowsError [Int]
convertToNumList inp = runTreeParser inp 
    >>= convertToList 
    >>= mapM convertToNum 
    >>= return

runConv = runExcept . convertToNumList 

conv inp = case runConv inp of
    (Left err) -> show err
    (Right ok) -> show ok

guardError :: Bool -> ConvError -> ThrowsError ()
guardError b err = unless b $ throwError err

isNil Nil = True
isNil _ = False

convertToNum :: HTree -> ThrowsError Int
convertToNum tree = case tree of
    Nil -> return 0

    (Node b1 b2) -> do
        guardError (isNil b1) (NumError b1)
        n2 <- convertToNum b2
        return $ 1 + n2

convertToList :: HTree -> ThrowsError [HTree]
convertToList tree = case tree of
    Nil -> return []

    (Node b1 b2) -> do
        l2 <- convertToList b2
        return $ b1 : l2
