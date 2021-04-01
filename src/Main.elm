module Main exposing (..)

import Html exposing ( Html, div, text, h1, h2, h3, p, img, a )
import Html.Attributes exposing ( class, href, src )
import Browser

import Task

import Json.Decode exposing (Decoder, field, string, list)
import Http

import DividerLine exposing ( dividerLine, dividerLineShort )

---- TESTDATA ----
subHeaderList =
    [ "Bare ræl"
    , "Også på Skedsmo"
    , "Generell rivning"
    , "På forhånd beklager"
    , "Derav søksmålet"
    , "JABEEEEE"
    , "aaaaaaaa"
    , "Mjukvara på norsk"
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
urlHaiku = "/bad/haiku"

type alias Haiku = List String
type alias HeaderText = String

type alias Article =
    { title: String
    , ingress: String 
    , imageURL: String
    , articleURL: String
    }


-- Wrapper for any fetched content.
-- Empty = have not yet tried to fetch
-- Valid = tried to fetch and succeded
-- Failed = tried to fetch and failed. String for error message
type Resource a
    = Empty
    | Valid a
    | Failed String
    
type alias Model =
    { haiku: Resource Haiku
    , subHeader: Resource HeaderText
    , articles: Resource (List Article)
    }
     

init : () -> (Model, Cmd Msg)
init _ =
    (
     {haiku = Empty, subHeader = Empty, articles = Empty}
    , loadData
    )


---- Update ----
type Msg
    = LoadHaiku
    | GotHaiku (Result Http.Error (List String))
    | LoadSubHeading 
    | GotSubHeading HeaderText
    | LoadArticles
    | GotArticles (List Article)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LoadHaiku ->
            (model, getHaiku)
        GotHaiku result ->
            case result of
                Ok newHaiku ->
                    ({model | haiku = Valid newHaiku}, Cmd.none)
                        
                Err _ -> 
                    ({model | haiku = Failed "No haiku for you"}, Cmd.none)
            
        _ -> (model, Cmd.none)
            

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
    let haikuBody =
            case model.haiku of
                Empty -> 
                    [
                     h2 [ class "haiku" ] [text "Loading..."]
                    ]

                Valid haikuLines ->
                    [
                      renderList haikuLines
                    , h2 [class "what"] [
                          a
                          [ href "https://github.com/mjukvarelauget/badhaiku" ]
                          [ text "Hæ?" ] 
                         ]
                    ]

                Failed message ->
                    [
                     h2 [ class "haiku" ] [text "No Haiku for you"]
                    ]
                    
        
    in                
        div [class "haiku-wrapper"] haikuBody
        
        
articlesView : Model -> Html Msg
articlesView model =
    div [class "articles-wrapper" ] [
         featuredArticleView (Valid dummyArticle1)
        , div [class "articles-list"] [
              articleView (Valid dummyArticle2)
             ,articleView (Valid dummyArticle3)
             ,articleView (Valid dummyArticle4)
             ]
        ]

featuredArticleView : Resource Article -> Html Msg
featuredArticleView article =
    case article of
        Valid content ->
            div [class "featured-article"] [
                 div [class "featured-image-box"] [
                      img [class "featured-image", src content.imageURL] []
                     ]
                     
                , div [class "featured-text"] [
                      a [class "featured-heading", href content.articleURL] [
                           h2 [class "no-top-margin"] [
                                text content.title
                               ]
                          ]
                     , dividerLineShort
                     , p [class "text-box-text"] [
                           text content.ingress
                          ]
                     ]
               ]
                
        Empty ->
            div [class "featured-article"] [
                 text "Loading featured article"
                ]

        Failed message ->
            div [class "featured-article"] [
                 text message
                ]

            
articleView : Resource Article -> Html Msg
articleView article =
    case article of
        Valid content ->
            a [class "article-box", href content.articleURL] [
                 div [class "article-image-box"] [
                      img [src content.imageURL][]
                     ]
                , dividerLineShort
                , h3 [class "article-header"] [
                      text content.title
                     ]
                ]
        Empty ->
            div [class "article-box"] [
                text "Loading article ..."
                ]

        Failed message ->
            div [class "article-box"] [
                text message
                ]
        
                
renderList : List String -> Html Msg
renderList lst =
    div []
        (List.map (\l -> h2 [] [ text l ]) lst)

---- State ----
loadData : Cmd Msg
loadData =
    Cmd.batch [
         getHaiku
         ]
    
---- HTTP ----
getHaiku : Cmd Msg
getHaiku = 
    Http.get
        { 
          url = urlBase ++ urlHaiku
        , expect = Http.expectJson GotHaiku haikuDecoder
        }

haikuDecoder : Decoder (List String)
haikuDecoder = 
    field "haiku" (list string)

---- PROGRAM ----
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
