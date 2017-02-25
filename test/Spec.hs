import FParser
import FPrint

main :: IO ()
main = do
    putStrLn "\n"
    putStrLn (datafyProg testProgram1)
    putStrLn (datafyProg testProgram2)
    putStrLn (datafyProg testProgram3)

testProgram1 = parseProgram "input X output f(X) where f(X) = if hd X then cons nil f(cons tl hd X cons hd tl X nil) else hd tl X"
testProgram2 = parseProgram "input X output f(X) where f(X) = nil"
testProgram3 = parseProgram "input X output cons nil f(X) where f(X) = if X then cons nil f(tl X) else nil"
