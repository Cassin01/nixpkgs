Config {

   -- appearance
     font =         "xft:Fira Code:pixelsize=16:antialias=true:hinting=true" -- "xft:Bitstream Vera Sans Mono:size=9:bold:antialias=true"
   , bgColor =      "#1e2030"
   , fgColor =      "#cad3f5"
   , position =     Top
   , border =       NoBorder -- BottomB
   , borderColor =  "#646464"

   -- layout
   , sepChar =  "%"   -- delineator between plugin names and straight text
   , alignSep = "}{"  -- separator between left-right alignment
   -- , template = "%battery% | %multicpu% | %coretemp% | %memory% | %dynnetwork% }<fc=#ff000f>my xmobar</fc>{ %RJTT% | %date% || %kbd% "
   , template = "%battery% %multicpu% %coretemp% %memory% %dynnetwork% }{ %RJTT% %date% | %kbd% "

   -- general behavior
   , lowerOnStart =     True    -- send to bottom of window stack on start
   , hideOnStart =      False   -- start with window unmapped (hidden)
   , allDesktops =      True    -- show on all desktops
   , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
   , pickBroadest =     False   -- choose widest display (multi-monitor)
   , persistent =       True    -- enable/disable hiding (True = disabled)

   -- plugins
   --   Numbers can be automatically colored according to their value. xmobar
   --   decides color based on a three-tier/two-cutoff system, controlled by
   --   command options:
   --     --Low sets the low cutoff
   --     --High sets the high cutoff
   --
   --     --low sets the color below --Low cutoff
   --     --normal sets the color between --Low and --High cutoffs
   --     --High sets the color above --High cutoff
   --
   --   The --template option controls how the plugin is displayed. Text
   --   color can be set by enclosing in <fc></fc> tags. For more details
   --   see http://projects.haskell.org/xmobar/#system-monitor-plugins.
   , commands =

        -- weather monitor
        [ Run Weather "RJTT" [ "--template", "<skyCondition> | <fc=#8aadf4><tempC></fc>°C | <fc=#8aadf4><rh></fc>% | <fc=#8aadf4><pressure></fc>hPa"
                             ] 36000

        -- network activity monitor (dynamic interface resolution)
        , Run DynNetwork     [ "--template" , "<dev>: <tx>kB/s|<rx>kB/s"
                             , "--Low"      , "1000"       -- units: B/s
                             , "--High"     , "5000"       -- units: B/s
                             , "--low"      , "#8bd5ca"
                             , "--normal"   , "#f5a97f"
                             , "--high"     , "#ed8796"
                             ] 10

        -- cpu activity monitor
        , Run MultiCpu       [ "--template" , "Cpu: <total0>%|<total1>%"
                             , "--Low"      , "50"         -- units: %
                             , "--High"     , "85"         -- units: %
                             , "--low"      , "#8bd5ca"
                             , "--normal"   , "#f5a97f"
                             , "--high"     , "#ed8796"
                             ] 10

        -- cpu core temperature monitor
        , Run CoreTemp       [ "--template" , "Temp: <core0>°C|<core1>°C"
                             , "--Low"      , "70"        -- units: °C
                             , "--High"     , "80"        -- units: °C
                             , "--low"      , "#8bd5ca"
                             , "--normal"   , "#f5a97f"
                             , "--high"     , "#ed8796"
                             ] 50

        -- memory usage monitor
        , Run Memory         [ "--template" ,"Mem: <usedratio>%"
                             , "--Low"      , "20"        -- units: %
                             , "--High"     , "90"        -- units: %
                             , "--low"      , "#8bd5ca"
                             , "--normal"   , "#f5a97f"
                             , "--high"     , "#ed8796"
                             ] 10

        -- battery monitor
        , Run Battery        [ "--template" , "Batt: <acstatus>"
                             , "--Low"      , "10"        -- units: %
                             , "--High"     , "80"        -- units: %
                             , "--low"      , "#ed8796"
                             , "--normal"   , "#f5a97f"
                             , "--high"     , "#8bd5ca"

                             , "--" -- battery specific options discharging status
                                       , "-o"	, "<left>% (<timeleft>)"
                                       -- AC "on" status
                                       , "-O"	, "<fc=#eed48f>Charging</fc>"
                                       -- charged status
                                       , "-i"	, "<fc=#86c5d2>Charged</fc>"
                             ] 50

        -- time and date indicator
        --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
        , Run Date           "<fc=#ABABAB>%F (%a) %T</fc>" "date" 10

        -- keyboard layout indicator
        , Run Kbd            [ ("us(dvorak)" , "<fc=#8aadf4>DV</fc>") -- "<fc=#00008B>DV</fc>")
                             , ("us"         , "<fc=#ed8796>US</fc>") -- "<fc=#8B0000>US</fc>")
                             ]
        ]
   }
