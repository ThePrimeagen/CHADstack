{-# LANGUAGE OverloadedStrings #-}

module Main where

import Network.Wai
import Network.Wai.Application.Classic hiding ((</>))
import Network.Wai.Handler.Warp
import System.Directory
import System.FilePath

main :: IO ()
main = do
  dir <- getCurrentDirectory
  putStrLn "Server running"
  let settings = setPort 80 defaultSettings
  runSettings settings $ app dir

app :: FilePath -> Application
app dir =
  cgiApp
    defaultClassicAppSpec
    defaultCgiAppSpec
    CgiRoute
      { cgiSrc = "/"
      , cgiDst = fromString (dir </> "cgi-bin")
      }


