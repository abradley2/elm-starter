module Layout exposing (layout)

import Css exposing (..)
import Css.Colors
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Message exposing (Message, Message(..))
import Message.LayoutMessage exposing (LayoutMessage, LayoutMessage(..))
import Model exposing (Model)


toggleSidenavButton : Html LayoutMessage
toggleSidenavButton =
    div
        [ css
            [ position absolute
            , top (px 0)
            , left (px 0)
            , Css.width (px 56)
            , Css.height (px 56)
            , backgroundColor Css.Colors.red
            , cursor pointer
            ]
        , onClick ToggleSidenav
        ]
        [ text "test"
        ]


sideNavtransform isOpen =
    if isOpen then
        "translateX(0%)"
    else
        "translateX(-105%)"


layout : Model -> Html Message -> Html Message
layout model view =
    div
        [ css
            [ paddingTop (px 60) ]
        ]
        [ Html.Styled.map Layout toggleSidenavButton
        , Html.Styled.map Layout
            (ul
                [ id "slide-out"
                , class "sidenav"
                , onClick ToggleSidenav
                , style
                    [ ( "transform", sideNavtransform model.layoutModel.sidenavOpen )
                    , ( "transition", ".25s" )
                    ]
                ]
                [ li []
                    [ a [ href "#units" ] [ text "Units" ]
                    ]
                , li []
                    [ a [ href "#wargear" ] [ text "Wargear" ]
                    ]
                ]
            )
        , view
        ]
