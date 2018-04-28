module Page.Quests.QuestAction exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Theme


type alias Params a =
    { a
        | text : String
        , icon : String
        , href : String
    }


questAction : Params b -> Html a
questAction params =
    a
        [ href params.href
        , attribute "data-link" params.href
        , css
            [ paddingTop (px 8)
            , cursor Css.pointer
            , displayFlex
            , color Theme.white
            ]
        ]
        [ span
            [ css
                [ padding4 (px 0) (px 16) (px 0) (px 16)
                , displayFlex
                , alignItems center
                , Css.height (px 48)
                , backgroundColor Theme.accentColor
                , fontSize (px 16)
                , minWidth (px 125)
                ]
            , attribute "data-link" params.href
            ]
            [ text params.text ]
        , span
            [ css
                [ backgroundColor Theme.accentColor
                , borderTopRightRadius (pct 50)
                , borderBottomRightRadius (pct 50)
                , displayFlex
                , Css.width (px 40)
                , Css.height (px 48)
                , alignItems center
                , justifyContent center
                ]
            , attribute "data-link" params.href
            ]
            [ i
                [ class ("fa fa-lg fa-" ++ params.icon)
                , attribute "data-link" params.href
                , css
                    [ color Theme.white
                    , fontSize (px 16)
                    ]
                ]
                []
            ]
        ]
