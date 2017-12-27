module Layout exposing (layout)

import Css exposing (..)
import Css.Colors
import Html
import Html.Events exposing (onWithOptions)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Message exposing (Message, Message(..))
import Message.LayoutMessage exposing (LayoutMessage, LayoutMessage(..))
import Model exposing (Model)


{-
   <select class="browser-default">
      <option value="" disabled selected>Choose your option</option>
      <option value="1">Option 1</option>
      <option value="2">Option 2</option>
      <option value="3">Option 3</option>
    </select>
-}


navs : List (Html LayoutMessage)
navs =
    [ li
        []
        [ div
            [ onWithOptions "click" (Json.Decode.Decoder msg)
            ]
            [ select [ class "browser-default" ]
                [ option [] [ text "option 1" ]
                , option [] [ text "option 2" ]
                ]
            ]
        ]
    , li []
        [ a [ href "#units" ] [ text "Units" ]
        ]
    , li []
        [ a [ href "#wargear" ] [ text "Wargear" ]
        ]
    ]


navbar : Html LayoutMessage
navbar =
    nav []
        [ div
            [ class "nav-wrapper"
            ]
            [ toggleSidenavButton
            , ul [ class "right hide-on-small-only" ] navs
            ]
        ]


toggleSidenavButton : Html LayoutMessage
toggleSidenavButton =
    a
        [ href "javascript:void(0);"
        , class "left brand-logo show-on-small"
        , onClick ToggleSidenav
        ]
        [ text "Menu"
        ]


sideNavtransform isOpen =
    if isOpen then
        "translateX(0%)"
    else
        "translateX(-105%)"


layout : Model -> Html Message -> Html Message
layout model view =
    div
        []
        [ Html.Styled.map Layout navbar
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
                navs
            )
        , view
        ]
