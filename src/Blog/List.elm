module Blog.List exposing (main)
import Html exposing (Html, text)
import Html.Attributes exposing (..)

emptyArticle =
    { title = "EMPTY"
    , ingress = "EMPTY"
    , imgAlt = "EMPTY"
    , imageURL = "EMPTY"
    , slug = "EMPTY"
    }

cmsApiUrlBase = "https://ll3wkgw3.api.sanity.io/v1/data/query/production/"

articlesQuery = """
*[_type == 'post'] | [0..3] | order(_createdAt asc) | 
{
author->{name}, 
ingress, 
mainImage{asset->{originalFilename, path}},
title,
slug
}
"""

queryUrl = cmsApiUrlBase ++ articlesQuery

main : Html msg 
main = text "No page yet!"