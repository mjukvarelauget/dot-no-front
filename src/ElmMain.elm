module ElmMain exposing (main)

import Html exposing ( Html, div, text, h1, h2, h3, p, img, a )
import Html.Attributes exposing ( class, href, src, alt )
import Browser

import Json.Decode exposing (Decoder, field, string, list, map, map5)
import Http
import Random

import Array
--- import List <- imported by default

import DividerLine exposing ( dividerLine, dividerLineShort )

softHyphen = "\u{00AD}"

---- MODEL ----
subHeaderList : List String
subHeaderList =
    [ "Bare ræl"
    , "Også på Skedsmo"
    , "Generell rivning"
    , "På forhånd beklager"
    , "Derav søksmålet"
    , "JABEEEEE"
    , "aaaaaaaa"
    , "Mjukvara på norsk"
    , "Typisk Erling"
    , "God tid og dårlig dømmekraft"
    ]

emptyArticle =
    { title = "EMPTY"
    , ingress = "EMPTY"
    , imgAlt = "EMPTY"
    , imageURL = "EMPTY"
    , slug = "EMPTY"
    }
    
---- MODEL ----
cmsApiUrlBase = "https://ll3wkgw3.api.sanity.io/v1/data/query/production/"
cmsUrlBase = "https://cdn.sanity.io/"
-- Only fetches the 3 most recent to display in homepage
articlesQuery = """
*[_type == 'post'] | [0..2] | order(_createdAt asc) | 
{
author->{name}, 
body[0]{children[0]{text}}, 
mainImage{asset->{originalFilename, path}},
title,
slug
}
"""


urlBase : String
urlBase = "https://mjukvare-no-api.herokuapp.com/"
urlHaiku = "/bad/haiku"

type alias Haiku = List String
type alias HeaderText = String

type alias Article =
    { title: String
    , ingress: String
    , imgAlt: String
    , imageURL: String
    , slug: String
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
    | LoadSubHeader 
    | GotSubHeaderIndex Int
    | LoadArticles
    | GotArticles (Result Http.Error (List Article))

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

        LoadSubHeader ->
            (model, getSubHeader)

        GotSubHeaderIndex index ->
            let headerListElement = Array.get index (Array.fromList subHeaderList)
           
            in
                case headerListElement of
                    Just headerText ->
                        ({model | subHeader = Valid headerText}, Cmd.none)
                    Nothing ->
                        ({model | subHeader = Failed "No subheader found"}, Cmd.none)
                
        GotArticles result ->
            case result of
                Ok fetchedArticles ->
                    ({model | articles = Valid fetchedArticles}, Cmd.none)

                Err m ->
                    case m of
                        Http.BadBody str ->
                            (
                             {model | articles = Failed ("The json decode failed:" ++ str)}
                            , Cmd.none
                            )
                        _ ->
                            ({model | articles = Failed "no articles for you"}, Cmd.none)
                        
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
    let headerText =
            case model.subHeader of
                Empty -> "Loading"
                Valid text -> text
                Failed message -> message
                

    in
        div [ class "title" ]
            [ h1 [ class "title-top" ]
                  [
                   text ("Mjukvare"++softHyphen++"lauget")
                  ]
            , dividerLineShort
            , h2 [ class "title-bottom"] [ text headerText ]
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
    case model.articles of
        Empty ->
            div [class "articles-wrapper" ] [
                 text "Loading articles..."
                ]
        Failed m ->
            div [class "articles-wrapper" ] [
                 text ("Something went wrong while loading the articles: " ++ m)
                ]
        Valid articles ->
            showLoadedArticles articles

showLoadedArticles : (List Article) -> Html Msg
showLoadedArticles articles =    
    -- "<<" is function composition (f << g) x  == f(g(x))
    div [class "articles-wrapper" ] [
         h1 [class "articles-header"] [
              text "Prosjekter og blogginnlegg"
             ]
        , div
             [class "articles-list"]
             (List.map (articleView << Valid) articles)
        , div [class "blog-link-wrapper"] [
              a [class "blog-link", href "/blog/"] [
                   text "Se alle innlegg"
                  ]
             ]
        ]
            
articleView : Resource Article -> Html Msg
articleView article =
    case article of
        Valid content ->
            a [class "article-box", href ("/blog/" ++ content.slug)] [
                 div [class "article-image-box"] [
                      img [src content.imageURL, alt content.imgAlt][]
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
                text ("Article load failed: " ++ message)
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
        , getSubHeader
        , getArticleData
        ]

---- Random ----
getSubHeader : Cmd Msg
getSubHeader =
    Random.generate GotSubHeaderIndex (Random.int 0 ((listLength subHeaderList) - 1 ))

---- HTTP ----
getArticleData : Cmd Msg
getArticleData =
    Http.get
        {
          url = cmsApiUrlBase ++ "?query=" ++ articlesQuery
        , expect = Http.expectJson GotArticles articleDataDecoder
        }


articleDataDecoder : Decoder (List Article)
articleDataDecoder =
    (field
         "result"
         (list
              (
               map5 Article
               (field "title" string)
               (field "body"
                    (field "children"
                         (field "text" string)
                    )
               )
               (field "mainImage"
                    (field "asset"
                         (field "originalFilename" string)
                    )
               )
               (map buildImageUrl
                    (field "mainImage"
                         (field "asset"
                              (field "path" string)
                         )
                    )
               )
               (field "slug" (field "current" string ))
              )
         )
    )

---- Utils ----
listLength : List a -> Int
listLength list =
    case list of
        [] -> 0
        (head::tail) -> 1 + listLength tail

buildslug : String -> String
buildslug path = "/" ++ path

buildImageUrl : String -> String
buildImageUrl path = cmsUrlBase ++ path ++ "?w=500&h=500"
        
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
