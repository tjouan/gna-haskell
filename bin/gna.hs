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
  putStrLn $ show repos
  appendFile rcFilePath $ show repos ++ "\n"


list :: [String] -> IO ()
list [] = putStrLn "list"


check :: [String] -> IO ()
check [] = putStrLn "check"


findRepos :: [Char] -> IO [FilePath]
findRepos = globDir1 $ compile "**/.git"
