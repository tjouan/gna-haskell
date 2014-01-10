#!/usr/bin/env runhaskell

import System.Environment
import System.FilePath.Glob

findRepos :: [Char] -> IO [FilePath]
findRepos path = globDir1 (compile "**/.git") path

main = do
  progName <- getProgName
  args <- getArgs
  putStrLn progName
  print args

  findRepos ".."
