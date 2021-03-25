module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing ( class, href )
import DividerLine exposing (..)
import SpinLoader exposing (..)
import Http exposing (..)
import Json.Decode exposing (Decoder, field, string, list)

import Random


---- MODEL ----


urlBase = "https://mjukvare-no-api.herokuapp.com/"

type alias HeaderText = String
type alias State = {haiku : (List String), subheader : HeaderText}

type Model 
    = Failure
    | LoadingHeader
    | LoadingHaiku HeaderText
    | Success State

init : () -> (Model, Cmd Msg)
init _  = 
    ( LoadingHeader, getRandomHeader)



---- UPDATE ----

type Msg
    = GetSubHeader
    | GotSubHeaderIndex Int
    | GetHaiku
    | GotHaiku (Result Http.Error (List String))

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetSubHeader ->
            (model, getRandomHeader)
                
        GotSubHeaderIndex newSubHeaderIndex -> 
            update GetHaiku (LoadingHaiku (getHeaderFromList newSubHeaderIndex))
            
        GetHaiku -> 
            (model, getHaiku)

        GotHaiku result -> 
            case result of 
                Ok newHaiku ->
                    case model of
                        LoadingHaiku newHeader ->
                            (Success {haiku = newHaiku, subheader = newHeader}, Cmd.none)
                        _ ->
                            (Success {haiku = newHaiku, subheader = "no header!"}, Cmd.none)
                Err _ -> 
                    (Failure, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
---- VIEW ----

view : Model -> Html Msg
view model =
    div [] [
         headerView model
        ,haikuView model
    ]

headerView : Model -> Html Msg
headerView model =
    case model of
        LoadingHeader ->
            div [ class "title" ]
                [ h1 [ class "title-top" ] [ text "Mjukvarelauget" ]
                , dividerLine
                , h2 [ class "title-bottom"] [ text "loading ..." ]
                ]
        
        LoadingHaiku headerText ->
            div [ class "title" ]
                [ h1 [ class "title-top" ] [ text "Mjukvarelauget" ]
                , dividerLine
                , h2 [ class "title-bottom"] [ text headerText ]
                ]

        Success state ->
            div [ class "title" ]
                [ h1 [ class "title-top" ] [ text "Mjukvarelauget" ]
                , dividerLine
                , h2 [ class "title-bottom"] [ text state.subheader ]
                ]
        Failure ->
            div [ class "title" ]
                [ h1 [ class "title-top" ] [ text "Mjukvarelauget" ]
                , dividerLine
                , h2 [ class "title-bottom"] [ text "Failed to load" ]
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

        LoadingHeader ->
            div [class "haiku-wrapper"] [ 
                 h2 [ class "haiku" ] [text "Loading..."] 
                ]

        LoadingHaiku _ ->
            div [class "haiku-wrapper"] [ 
                 h2 [ class "haiku" ] [text "Loading..."] 
                ]

        Success state -> 
            div [ class "haiku-wrapper" ] [
                renderList state.haiku
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

-- Random
getRandomHeader : Cmd Msg
getRandomHeader =
    Random.generate GotSubHeaderIndex (Random.int 0 6)

getHeaderFromList : Int -> String
getHeaderFromList index =
   case index of
       0 -> "Bare ræl"
       1 -> "Også på Skedsmo"
       2 -> "Generell rivning"
       3 -> "På forhånd beklager"
       4 -> "Derav søksmålet"
       5 -> "JABEEEEE"
       6 -> "aaaaaaaa"
       _ -> "header list index out of bounds"
