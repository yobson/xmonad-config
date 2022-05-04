module James.Loggers where

import XMonad (liftIO, gets)
import XMonad.Core
import qualified XMonad.StackSet as W
import XMonad.Util.Loggers
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Font (Align (..))
import XMonad.Util.NamedWindows (getName)
import Data.List
import Data.Maybe

import Control.Exception as E

withScreen f n = do
  ss <- withWindowSet $ return . W.screens
  case find ((== n) . W.screen) ss of
    Just s  -> f s
    Nothing -> pure Nothing

logTitlesRev :: (String -> String) -> (String -> String) -> Logger
logTitlesRev formatFoc formatUnfoc = do
  sid <- gets $ W.screen . W.current . windowset
  logTitlesOnScreenRev sid formatFoc formatUnfoc

logTitlesOnScreenRev sid formatFoc formatUnfoc = (`withScreen` sid) $ \screen -> do
  layout <- fromMaybe "" <$> logLayout
  let focWin = fmap W.focus . W.stack . W.workspace $ screen
      wins   = (if "ReflectX" `isInfixOf` layout then reverse else id) $ maybe [] W.integrate . W.stack . W.workspace $ screen
  winNames <- traverse (fmap show . getName) wins
  pure . Just
       . unwords
       $ zipWith (\w n -> if Just w == focWin then formatFoc n else formatUnfoc n)
                 wins
                 winNames

