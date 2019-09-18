module SpinLoader exposing (spinLoader)

import Html exposing (..)
import Html.Attributes exposing (..)

spinLoader : Html msg 
spinLoader = 
    div [ class "spin-container" ] [
        div [ class "spin-loader"  ] [
            div [ class "pulse-loader" ] [
                img [ src "/assets/mjukvarekryss.png" ] []
            ]
        ]
    ]