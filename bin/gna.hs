#!/usr/bin/env runhaskell

import System.Environment
import System.FilePath.Glob

findRepos p = globDir1 (compile "**/.git") p

main = do
  progName <- getProgName
  args <- getArgs
  putStrLn progName
  print args

  findRepos ".."
