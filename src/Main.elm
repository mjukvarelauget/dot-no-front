module Main exposing (..)

import Html exposing ( Html, div, text, h1, h2, a )
import Html.Attributes exposing ( class, href )
import DividerLine exposing ( dividerLine, dividerLineShort )
import Browser

---- TESTDATA ----
subHeaderList =
    [ "Bare ræl"
    , "Også på Skedsmo"
    , "Generell rivning"
    , "På forhånd beklager"
    , "Derav søksmålet"
    , "JABEEEEE"
    , "aaaaaaaa"
    ]

dummyHaiku =
    ["test test mange test"
    ,"mange sauer på en gang"
    ,"brølende breking"]

dummyArticle1 =
    { title = "test1"
    , ingress = "spennende med kniv!"
    , image = "image1.url"
    }

dummyArticle2 =
    { title = "Kålprisene stiger igjen"
    , ingress = "Hva med potet?"
    , image = "image2.url"
    }

dummyArticle3 =
    { title = "17 store epler på en gang"
    , ingress = "Du trenger et trau"
    , image = "image3.url"
    }

dummyArticles =
    [ dummyArticle1
    , dummyArticle2
    , dummyArticle3
    ]
    
---- MODEL ----
urlBase = "https://mjukvare-no-api.herokuapp.com/"

type alias Haiku = List String
type alias HeaderText = String
type alias ArticleInfo =
    { title: String
    , ingress: String 
    , image: String
    }
          
type alias State =
    { haiku: Haiku
    , subHeader: HeaderText
    , articles: List ArticleInfo
    }
     
type Model
    = Failiure
    | Loading State
    | Success State

init : () -> (Model, Cmd Msg)
init _ =
    (Failiure, Cmd.none)


---- Update ----
type Msg = Nei


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Nei -> 
            (Failiure, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [] [
         div [class "content-wrapper"] [
              div [class "content-column"] [
                   headerView model
                  , dividerLine
                  , haikuView model
                  , dividerLine
                  , articlesView model
                  ]
             ]
        ]

headerView : Model -> Html Msg
headerView model =
    div [ class "title" ]
        [ h1 [ class "title-top" ] [ text "Mjukvarelauget" ]
        , dividerLineShort
        , h2 [ class "title-bottom"] [ text "Bare ræl" ]
        ]

haikuView : Model -> Html Msg
haikuView model =
    div [ class "haiku-wrapper" ] [
         renderList dummyHaiku
        ,h2 [class "what"] [
              a [ href "https://github.com/mjukvarelauget/badhaiku" ] [ text "Hæ?" ] 
             ]
        ]

articlesView : Model -> Html Msg
articlesView model = div [class "articles-wrapper" ] [
                     
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
