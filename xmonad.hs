import XMonad
import System.Exit

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.Loggers

import XMonad.StackSet
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

-- Layputs
import XMonad.Layout.MultiColumns
import XMonad.Layout.Reflect
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.TwoPane

import James.Loggers

import Paths_xmonad_config

myConfig ddir = def 
  { terminal    = "xfce4-terminal"
  , layoutHook  = myLayouts
  , startupHook = spawn "~/.config/xmonad/other/startup.sh"
  }
  `removeKeysP`
  [ "M-S-q"
  , "M-S-j"
  , "M-S-l"
  ]
  `additionalKeysP`
  [ ("M-<Return>"  , spawn "xfce4-terminal")
  , ("M-S-q"       , kill)
  , ("M-<Space>"   , spawn "rofi -show drun")
  , ("M-S-<Left>"  , windows swapDown)
  , ("M-S-<Right>" , windows swapUp)
  , ("M-S-<Return>", windows swapMaster)
  , ("M4-<Tab>"    , sendMessage NextLayout)
  , ("M4-1"        , sendMessage $ JumpToLayout "ReflectX MultiCol")
  , ("M4-2"        , sendMessage $ JumpToLayout "TwoPane")
  , ("M4-3"        , sendMessage $ JumpToLayout "Tall")
  , ("M-f"         , sendMessage $ JumpToLayout "Full")
  , ("M-<Left>"    , windows focusDown)
  , ("M-<Right>"   , windows focusUp)
  , ("M-S-l"       , io exitSuccess)
  ]

myGaps = [(U, 5), (R, 5), (D,5), (L,5)]

myLayouts = smartBorders $ gaps myGaps $ spacing 5 $
      reflectHoriz (multiCol [1] 1 0.01 (-0.5))
  ||| TwoPane (3/100) (17/24)
  ||| Tall 1 (3/100) (17/24)
  ||| Full

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitlesRev formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 50

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

main :: IO ()
main = do
  ddir <- getDataDir
  xmonad 
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar ~/.config/xmonad/other/xmobar.hs" (pure myXmobarPP)) toggleStrutsKey
     $ myConfig ddir
  where
    toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
    toggleStrutsKey XConfig{ modMask = m } = (m, xK_b)
