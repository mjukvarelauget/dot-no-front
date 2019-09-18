module DividerLine exposing (dividerLine)

import Html exposing (Html, text, img, span, div, p, hr)
import Html.Attributes exposing (..)

dividerLine : Html msg 
dividerLine = 
    div [ class "divider" ]
        [ hr [ class "line" ] [ ] 
        , span [ class "dot" ] [ 
            img [ src "/assets/mjukvarekryss.png", height 18, width 18 ] [ ]
        ]
    ]