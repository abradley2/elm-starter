module Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Home.Messages exposing (..)
import Home.Models exposing (Person)
import Models exposing (Model)


view : Model -> Html Msg
view model =
    div []
        [ nav model.home.people
        , input [ value model.home.newName, onInput EditNewName ] []
        , button [ onClick (AddPerson model.home.newName) ] [ text "Add Person" ]
        , list model.home.people
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
