{-# LANGUAGE ScopedTypeVariables #-}

import Control.Exception  (catch)
import System.Environment (getArgs)
import System.IO          (stdout, stderr, hPutStrLn)
import System.Exit
import Language.Boa.Types
import Language.Boa.Parser
import Language.Boa.Normalizer

--------------------------------------------------------------------------------
main :: IO ()
main = runCompiler `catch` esHandle

esHandle :: [UserError] -> IO ()
esHandle es = renderErrors es >>= hPutStrLn stderr >> exitFailure

runCompiler :: IO ()
runCompiler = do
  f <- getSrcFile
  s <- readFile f
  let af = (anormal . parse f) s
  let out = if isAnf af
            then "In ANF"
            else "Not in ANF: " ++ (pprint af)
  hPutStrLn stdout out
  exitSuccess

getSrcFile :: IO Text
getSrcFile = do
  args <- getArgs
  case args of
    [f] -> return f
    _   -> error "Please run with a single file as input"
