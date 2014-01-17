#!/usr/bin/env runhaskell

import Control.Monad (forM_)
import System.Process (createProcess, cwd, proc, waitForProcess)
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
  rcSaveRepos $ map gitRemoveSuffix repos

list :: [String] -> IO ()
list [] = rcRepos >>= \rs -> mapM_ putStrLn rs

check :: [String] -> IO ()
check [] = do
  rs <- rcRepos
  forM_ rs $ \repo -> do
    putStrLn $ unwords ["***", repo]
    forM_ gitCommands $ \args -> do
      (_, _, _, r) <- createProcess (proc git args) {
        cwd = Just repo
        }
      waitForProcess r
  where
    git = "git"
    gitCommands = [
      ["symbolic-ref", "--short", "HEAD"],
      ["status", "--porcelain"]
      ]


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

rcRepos :: IO [String]
rcRepos = rcFile >>= \rc -> return $ lines rc


findRepos :: String -> IO [FilePath]
findRepos = globDir1 $ compile "**/.git"


gitRemoveSuffix :: String -> String
gitRemoveSuffix path = reverse $ drop 5 $ reverse path
