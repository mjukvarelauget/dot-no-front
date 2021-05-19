module SpinLoader exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)

main : Html msg 
main = 
    div [ class "spin-container" ] [
        div [ class "spin-loader"  ] [
            div [ class "pulse-loader" ] [
                img [ src "/assets/mjukvarekryss.png" ] []
            ]
        ]
    ]