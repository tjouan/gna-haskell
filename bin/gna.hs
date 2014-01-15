#!/usr/bin/env runhaskell

import System.Environment (getArgs)
import System.FilePath.Glob (compile, globDir1)
import System.IO (appendFile)


rcFilePath :: String
rcFilePath = ".gna.rc"


dispatch :: [(String, [String] -> IO ())]
dispatch = [
  ("discover",  discover),
  ("list",      list),
  ("check",     check)
  ]


main = do
  (command:args) <- getArgs
  let (Just action) = lookup command dispatch
  action args


discover :: [String] -> IO ()
discover [path] = do
  repos <- findRepos path
  saveRCFile $ show repos ++ "\n"

list :: [String] -> IO ()
list [] = putStrLn "list"


check :: [String] -> IO ()
check [] = putStrLn "check"


findRepos :: String -> IO [FilePath]
findRepos = globDir1 $ compile "**/.git"

saveRCFile :: String -> IO ()
saveRCFile content = writeFile rcFilePath content
