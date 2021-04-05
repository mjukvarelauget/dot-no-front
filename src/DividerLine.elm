module DividerLine exposing (dividerLine, dividerLineShort)

import Html exposing (Html, img, span, div, hr)
import Html.Attributes exposing (..)

dividerLine : Html msg 
dividerLine = 
    div [ class "divider" ]
        [ hr [ class "line" ] [ ] 
        , span [ class "dot" ] [ 
            img [ src "/assets/mjukvarekryss.png", height 18, width 18 ] [ ]
        ]
    ]

dividerLineShort : Html msg 
dividerLineShort = 
    div [ class "divider short" ]
        [ hr [ class "line" ] [ ] 
        , span [ class "dot" ] [ 
            img [ src "/assets/mjukvarekryss.png", height 18, width 18 ] [ ]
        ]
    ]
