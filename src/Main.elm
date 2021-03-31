module Main exposing (..)

import Html exposing ( Html, div, text, h1, h2, h3, p, img, a )
import Html.Attributes exposing ( class, href, src )
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
    { title = "Kutt og kapp"
    , ingress = "Spennende med kniv! Å kappe ting er gøy. Kløyving er fett. Det å dele noe på midten, er gjevt. Det er derfor ikke overraskende at dagens unge kjøper fileteringskniver som aldri før."
    , imageURL = "assets/ekorn.jpg"
    , articleURL = "/ekorn.html"
    }

dummyArticle2 =
    { title = "Kålprisene stiger igjen"
    , ingress = "Hva med potet?"
    , imageURL = "assets/ekorn.jpg"
    , articleURL = "/ekorn.html"
    }

dummyArticle3 =
    { title = "17 store epler, på en gang"
    , ingress = "Du trenger et trau"
    , imageURL = "assets/ekorn.jpg"
    , articleURL = "/ekorn.html"
    }

dummyArticle4 =
    { title = "Hundeboom i Ørkelljunga"
    , ingress = "Nu jävlar, jag kräks. Inte har jag den snedblickan der"
    , imageURL = "assets/ekorn.jpg"
    , articleURL = "/ekorn.html"
    }
    
dummyArticles =
    [ dummyArticle1
    , dummyArticle2
    , dummyArticle3
    , dummyArticle4
    ]
    
---- MODEL ----
urlBase = "https://mjukvare-no-api.herokuapp.com/"

type alias Haiku = List String
type alias HeaderText = String
type alias Article =
    { title: String
    , ingress: String 
    , imageURL: String
    , articleURL: String
    }
          
type alias State =
    { haiku: Haiku
    , subHeader: HeaderText
    , articles: List Article
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
articlesView model =
    div [class "articles-wrapper" ] [
         div [class "featured-article"] [
              div [class "featured-image-box"] [
                   img [class "featured-image", src dummyArticle1.imageURL] []
                  ]
                  
             , div [class "featured-text"] [
                   a [class "featured-heading", href dummyArticle1.articleURL] [
                        h2 [class "no-top-margin"] [
                             text dummyArticle1.title
                            ]
                       ]
                  , dividerLineShort
                  , p [class "text-box-text"] [
                       text dummyArticle1.ingress
                      ]
                  ]
             ]
        , div [class "articles-list"] [
              articleView dummyArticle2
             ,articleView dummyArticle3
             ,articleView dummyArticle4
             ]
        ]

articleView : Article -> Html Msg
articleView article =
    a [class "article-box", href article.articleURL] [
          div [class "article-image-box"] [
               img [src article.imageURL][]
              ]
        , dividerLineShort
        , h3 [class "article-header"] [
               text article.title
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
