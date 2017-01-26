module Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Home.Messages exposing (..)
import Home.Models exposing (Person)


view : List Person -> Html Msg
view people =
    div []
        [ nav people
        , list people
        ]


nav : List Person -> Html Msg
nav people =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "People" ] ]


list : List Person -> Html Msg
list people =
    div [ class "p2" ]
        [ table []
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ]
                    , th [] [ text "Name" ]
                    , th [] [ text "Actions" ]
                    ]
                ]
            , tbody [] (List.map playerRow people)
            ]
        ]


playerRow : Person -> Html Msg
playerRow person =
    tr []
        [ td [] [ text person.id ]
        , td [] [ text person.name ]
        , td [] []
        ]
