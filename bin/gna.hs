#!/usr/bin/env runhaskell

import System.Environment (getArgs, getEnv)
import System.FilePath.Glob (compile, globDir1)
import System.IO (appendFile)


rcFileName :: String
rcFileName = ".gna.rc"

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
  rcSaveRepos repos

list :: [String] -> IO ()
list [] = rcFile >>= \rc -> putStr rc

check :: [String] -> IO ()
check [] = putStrLn "check"


rcFilePath :: IO String
rcFilePath = do
  home <- getEnv "HOME"
  return $ home ++ "/" ++ rcFileName

rcFile :: IO String
rcFile = rcFilePath >>= \p -> readFile p

rcSave :: String -> IO ()
rcSave content = do
  path <- rcFilePath
  writeFile path content

rcSaveRepos :: [String] -> IO ()
rcSaveRepos rs = rcSave $ unlines rs

findRepos :: String -> IO [FilePath]
findRepos = globDir1 $ compile "**/.git"
