module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, h2, img)
import Html.Attributes exposing (..)
import DividerLine exposing (..)
import SpinLoader exposing (..)

---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )

---- VIEW ----

view : Model -> Html Msg
view model =
    div [ class "title" ]
        [ h1 [] [ text "Mjukvarelauget" ]
        , dividerLine
        , h2 [] [ text "Bare ræl" ]
        , spinLoader
        , h2 [] [ text "Denne siden er under konstruksjon, kom tilbake senere takk"]
    ]

---- PROGRAM ----

main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
