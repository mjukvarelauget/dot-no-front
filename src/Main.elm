module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing ( class, href )
import DividerLine exposing (..)
import SpinLoader exposing (..)
import Http exposing (..)
import Json.Decode exposing (Decoder, field, string, list)


---- MODEL ----


urlBase = "https://mjukvare-no-api.herokuapp.com/"


type Model 
    = Failure
    | Loading
    | Success (List String)

init : () -> (Model, Cmd Msg)
init _  = 
    ( Loading, getHaiku )



---- UPDATE ----

type Msg
    = GetHaiku
    | GotHaiku (Result Http.Error (List String))

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetHaiku -> 
            (Loading, getHaiku)
        GotHaiku result -> 
            case result of 
                Ok haiku -> 
                    (Success haiku, Cmd.none)
            
                Err _ -> 
                    (Failure, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
---- VIEW ----

view : Model -> Html Msg
view model =
    div [] [
        div [ class "title" ]
            [ h1 [ class "title-top" ] [ text "Mjukvarelauget" ]
            , dividerLine
            , h2 [ class "title-bottom"] [ text "Bare ræl" ]
        ]
        ,haikuView model
    ]

haikuView : Model -> Html Msg
haikuView model =
    div [] [
        viewHaiku model 
    ]

viewHaiku : Model -> Html Msg
viewHaiku model =
    case model of 
        Failure -> 
            div [class "haiku-wrapper"] [ 
                h2 [ class "haiku" ] [text "No Haiku for you"] 
            ]

        Loading ->  div [class "haiku-wrapper"] [ 
                h2 [ class "haiku" ] [text "Loading..."] 
            ]

        Success haiku -> 
            div [ class "haiku-wrapper" ] [
                renderList haiku
                ,h2 [class "what"] [
                    a [ href "https://github.com/mjukvarelauget/badhaiku" ] [ text "Hæ?" ] 
                ]
            ]

renderList : List String -> Html Msg
renderList lst =
    div []
        (List.map (\l -> h2 [] [ text l ]) lst)
---- PROGRAM ----

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


-- HTTP
getHaiku : Cmd Msg
getHaiku = 
    Http.get
        { 
          url = urlBase ++ "/bad/haiku"
        , expect = Http.expectJson GotHaiku haikuDecoder
        }

haikuDecoder : Decoder (List String)
haikuDecoder = 
    field "haiku" (list string)
