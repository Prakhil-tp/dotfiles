-- IMPORTS
import XMonad
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

  -- Data
import Data.Monoid
import Data.Maybe (fromJust, isJust)

  -- Actions
import XMonad.Actions.WithAll (sinkAll, killAll)
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.GridSelect
import XMonad.Actions.Promote
import XMonad.Actions.MouseResize
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen, nextWS, prevWS)

   -- Utilities
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedWindows
import XMonad.Util.NamedScratchpad
import XMonad.Util.EZConfig (additionalKeysP)

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.UrgencyHook

  -- Layout Modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.LimitWindows (increaseLimit, decreaseLimit)
import XMonad.Layout.NoBorders
import XMonad.Layout.ShowWName
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace (onWorkspace)



-- my default programs
myTerminal :: String
myTerminal = "alacritty"

myBrowser :: String
myBrowser = "brave-browser" 

myFont :: String
myFont = "xft:Dank Mono:regular:size=9:antialias=true:hinting=true"


-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
myBorderWidth :: Dimension
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask :: KeyMask
myModMask       = mod4Mask

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset


-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces :: [String]
--myWorkspaces = [" dev ", " 2 ", " 3 ", " 4 ", " www ", " 6 ", " 7 ", " 8 ", " \xe271  "]
myWorkspaces = [" dev ", " 2 ", " 3 ", " 4 ", " www ", " 6 ", " 7 ", " 8 ", " mus "]
--myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]

myWorkspaceIndices :: M.Map String Integer
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..]  -- (,) == \x y -> (x,y)

--clickable :: String -> String
--clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    --where i = fromJust $ M.lookup ws myWorkspaceIndices

showNotification title text = spawn ("notify-send \"" ++ title ++ "\" \"" ++ text ++ "\"")

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor :: String
myNormalBorderColor  = "#282c34"

myFocusedBorderColor :: String
myFocusedBorderColor = "#46d9ff"

myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

myTabTheme :: Theme
myTabTheme = def {
      fontName            = myFont
    , activeColor         = "#46d9ff"
    , inactiveColor       = "#313846"
    , activeBorderColor   = "#46d9ff"
    , inactiveBorderColor = "#282c34"
    , activeTextColor     = "#282c34"
    , inactiveTextColor   = "#d0d0d0"
}

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }
------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout =
--      avoidStruts $
        onWorkspace " www " browser $
        smartBorders $
           tiled
           ||| Full
           ||| Mirror tiled
           ||| tabbed shrinkText myTabTheme
          
  where
     browser = (smartBorders $ Full)
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 2/100
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.

myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-C-r", spawn "xmonad --recompile")  -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")    -- Restarts xmonad
        , ("M-S-q", io exitSuccess)              -- Quits xmonad

    -- Run Dmenu Prompt
    --    , ("M-<Space>", spawn "dmenu_run -i -p \"Run: \"") -- Dmenu

    -- Run rofi prompt
        , ("M-<Space>", spawn "rofi -show drun -show-icons -config ~/.config/rofi/themes/dt-dmenu.rasi") 

    -- notifications
        , ("M-i t", showNotification "`date +\"%I:%M %p\"`" "`date +\"%A, %b %d\"`")

    -- Dmenu Prompts & application launch
        , ("M-p o", spawn "~/scripts/dm-sound")  -- choose sound output device
        , ("M-p b", spawn "~/scripts/dm-bluetooth")  -- bluetooth
        , ("M-p w", spawn "~/scripts/dm-wifi") -- wifi
        , ("M-p s", spawn "~/scripts/spotify") -- Run spotify
        , ("M-p .", spawn "~/scripts/change-wallpaper.sh") -- change wallpaper
        , ("M-p d", spawn "~/scripts/dm-dns") -- change DNS
        , ("M-p n", safeSpawnProg "simplenote") -- launch simplenote
        , ("M-p h", spawn (myTerminal ++ " -e htop")) -- htop

    -- Useful programs to have a keybinding for launch
        , ("M-<Return>", safeSpawnProg myTerminal)
        , ("M-b", safeSpawnProg myBrowser)
        , ("M1-<Tab>", spawn "rofi -show window")

    -- Shutdown
        , ("M1-C-<Delete>", spawn "~/scripts/dm-shutdown") -- shutdown/reboot/suspend/hibernate

    -- Float windows
        , ("M-S-t", withFocused $ windows . W.sink)  -- Push floating window back to tile

    -- Kill windows
        , ("M-S-c", kill1)     -- Kill the currently focused client
        , ("M-S-a", killAll)   -- Kill all windows on current workspace

    -- Workspaces
        , ("M-.", nextWS)  -- Switch focus to next monitor --
        , ("M-,", prevWS)  -- Switch focus to prev monitor --
        , ("M-S-<KP_Add>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

    -- Increase/decrease spacing (gaps)
        , ("C-M1-j", decWindowSpacing 4)         -- Decrease window spacing
        , ("C-M1-k", incWindowSpacing 4)         -- Increase window spacing
        , ("C-M1-h", decScreenSpacing 4)         -- Decrease screen spacing
        , ("C-M1-l", incScreenSpacing 4)         -- Increase screen spacing

    -- Grid Select (CTR-g followed by a key)
        -- , ("C-g g", spawnSelected' myAppGrid)                 -- grid select favorite apps
        , ("C-g t", goToSelected $ mygridConfig myColorizer)  -- goto selected window
        , ("C-g b", bringSelected $ mygridConfig myColorizer) -- bring selected window
            -- Windows navigation
        , ("M-m", windows W.focusMaster)  -- Move focus to the master window
        , ("M-j", windows W.focusDown)    -- Move focus to the next window
        , ("M-k", windows W.focusUp)      -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)   -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)     -- Swap focused window with prev window
        , ("M-<Backspace>", promote)      -- Moves focused window to master, others maintain order
        , ("M-S-<Tab>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
        , ("M-C-<Tab>", rotAllDown)       -- Rotate all the windows in the current stack

    -- Layouts
        , ("M-<Tab>", sendMessage NextLayout)           -- Switch to next layout
--        , ("M-u>", sendMessage (Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full

    -- Increase/decrease windows in the master pane or the stack
        , ("M-S-<Up>", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
        , ("M-S-<Down>", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane
        , ("M-C-<Up>", increaseLimit)                   -- Increase # of windows
        , ("M-C-<Down>", decreaseLimit)                 -- Decrease # of windows

    -- Window resizing
        , ("M-h", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                   -- Expand horiz window width
        , ("M-M1-j", sendMessage MirrorShrink)          -- Shrink vert window width
        , ("M-M1-k", sendMessage MirrorExpand)          -- Expand vert window width

    -- Sublayouts
    -- This is used to push windows to tabbed sublayouts, or pull them out of it.
        , ("M-C-h", sendMessage $ pullGroup L)
        , ("M-C-l", sendMessage $ pullGroup R)
        , ("M-C-k", sendMessage $ pullGroup U)
        , ("M-C-j", sendMessage $ pullGroup D)
        , ("M-C-m", withFocused (sendMessage . MergeAll))
        -- , ("M-C-u", withFocused (sendMessage . UnMerge))
        , ("M-C-/", withFocused (sendMessage . UnMergeAll))
        , ("M-C-.", onGroup W.focusUp')    -- Switch focus to next tab
        , ("M-C-,", onGroup W.focusDown')  -- Switch focus to prev tab

    -- Scratchpads
    -- Toggle show/hide these programs.  They run on a hidden workspace.
    -- When you toggle them to show, it brings them to your current workspace.
    -- Toggle them to hide and it sends them back to hidden workspace (NSP).
        , ("M-t", namedScratchpadAction myScratchPads "terminal")
        , ("C-s m", namedScratchpadAction myScratchPads "mocp")
        , ("C-s c", namedScratchpadAction myScratchPads "calculator")
        , ("M-e", namedScratchpadAction myScratchPads "vifm")
        ]
            -- The following lines are needed for named scratchpads.
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))



------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out the full
     -- name of my workspaces and the names would be very long if using clickable workspaces.
    [
     className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , className =? "confirm"         --> doFloat
    , className =? "file_progress"   --> doFloat
    , className =? "dialog"          --> doFloat
    , className =? "download"        --> doFloat
    , className =? "error"           --> doFloat
    , className =? "Gimp"            --> doFloat
    , className =? "notification"    --> doFloat
    , className =? "pinentry-gtk-2"  --> doFloat
    , className =? "splash"          --> doFloat
    , className =? "toolbar"         --> doFloat
    , title =? "Planner"             --> doShift (myWorkspaces !! 7)
    , (className =? "Spotify" <||> title =? "Spotify Free") --> doShiftAndGo (myWorkspaces !! 8)
--    , title =? "Mozilla Firefox"     --> doShift (myWorkspaces !! 4)
    , className =? "brave-browser"   --> doShift (myWorkspaces !! 4)
    , className =? "mpv"             --> doShift (myWorkspaces !! 7)
    , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
    , isFullscreen -->  doFullFloat
    ] <+> namedScratchpadManageHook myScratchPads
      where
        doShiftAndGo ws = doF (W.greedyView ws) <+> doShift ws


myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mocp" spawnMocp findMocp manageMocp
                , NS "calculator" spawnCalc findCalc manageCalc
                , NS "vifm" spawnVifm findVifm manageVifm
                ]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratterm"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnVifm  = myTerminal ++ " -t scratchpad -e ~/.config/vifm/scripts/vifmrun"
    findVifm   = title =? "scratchpad"
    manageVifm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMocp  = myTerminal ++ " -t mocp -e mocp"
    findMocp   = title =? "mocp"
    manageMocp = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w

    spawnCalc  = "qalculate-gtk"
    findCalc   = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
--myEventHook = mempty



------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
myStartupHook :: X()
myStartupHook = do
  spawnOnce "xsetroot -cursor_name left_ptr &" -- set default mouse cursor
  spawnOnce "nitrogen --restore &"
  spawnOnce "picom --experimental-backends &" -- tranparancy
  spawnOnce "conky -c $HOME/.config/conky/xmonad.conkyrc &"
  setWMName "LG3D"

------------------------------------------------------------------------
  -- MAIN
------------------------------------------------------------------------

main :: IO()
main = do
    --xmproc <- spawnPipe "xmobar /home/prakhil/.config/xmobar/xmobarrc"

    -- xmonad settings
    xmonad $ ewmh def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = showWName' myShowWNameTheme $ myLayout,
        manageHook         = myManageHook <+> manageDocks,
        handleEventHook    = docksEventHook <+> fullscreenEventHook,
        startupHook        = myStartupHook
        --logHook            = dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ xmobarPP {
            --ppOutput = hPutStrLn xmproc
          --, ppCurrent = xmobarColor "yellow" "" . wrap "[" "]" 
          --, ppHiddenNoWindows = xmobarColor "grey" ""          
          --, ppTitle   = xmobarColor "green"  "" . shorten 40   
          --, ppVisible = wrap "(" ")"                           
          --, ppUrgent  = xmobarColor "red" "yellow"             
        --}
    } `additionalKeysP` myKeys
