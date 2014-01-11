#!/usr/bin/env runhaskell

import Data.List
import System.Environment (getArgs)
import System.FilePath.Glob (compile, globDir1)


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


list :: [String] -> IO ()
list [] = putStrLn "list"


check :: [String] -> IO ()
check [] = putStrLn "check"


findRepos :: [Char] -> IO [FilePath]
findRepos path = globDir1 (compile "**/.git") path
