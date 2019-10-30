
import Html exposing (..)
import Html.Attributes exposing (..)
import DividerLine exposing (..)
import Http exposing (..)
import Json.Decode exposing (Decoder, field, string, list)



urlBase = "localhost:5000"


type Model 
    = Failure
    | Loading
    | Success (String)

init : () -> (Model, Cmd Msg)
init _  = 
    ( Loading, getHaiku )

type Msg
    = GetHaiku
    | GotHaiku (Result Http.Error String)

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

haikuView : Model -> Html Msg
haikuView model =
    div [] [
        dividerLine
        ,h2 [] [text "Hjælp"] 
        , viewHaiku model 
    ]

viewHaiku : Model -> Html Msg
viewHaiku model =
    case model of 
        Failure -> 
            div [] [ h2 [] [text "No Haiku for you"] ]

        Loading ->  h2 [] [ text "Laster den haiku" ]

        Success haiku -> 
            div [] [
                h2 [] [text haiku] 
            ]
    

-- HTTP
getHaiku : Cmd Msg
getHaiku = 
    Http.get
        { url = urlBase ++ "/bad/haiku"
        , expect = Http.expectJson GotHaiku haikuDecoder
        }

haikuDecoder : Decoder String
haikuDecoder = 
    field "haiku" string