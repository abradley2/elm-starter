module Layout exposing (layout)

import Css exposing (..)
import Css.Colors
import Http
import Html
import Html.Events exposing (onWithOptions)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Msg exposing (Msg, Msg(..))
import Msg.LayoutMsg exposing (LayoutMsg, LayoutMsg(..))
import Model exposing (Model)
import Update.SessionUpdate exposing (userIsLoggedIn)
import Component.TextField exposing (textField)


navs : Model -> List (Html LayoutMsg)
navs model =
    [ li []
        [ a [ href "#quests" ] [ text "Quests" ]
        ]
    , li []
        [ if userIsLoggedIn model.taco then
            a [ href "#profile" ] [ text "My Adventurer" ]
          else
            let
                ( route, location ) =
                    model.routeData
            in
                a
                    [ href ("https://www.facebook.com/v2.11/dialog/oauth?client_id=169926423737270&redirect_uri=" ++ location.origin ++ "&state=success") ]
                    [ i
                        [ css
                            [ transform (translateY (pct 25))
                            , paddingRight (px 8)
                            ]
                        , class "fab fa-2x fa-facebook"
                        ]
                        []
                    , span [] [ text "Login" ]
                    ]
        ]
    ]


navbar : Model -> Html LayoutMsg
navbar model =
    nav []
        [ div
            [ class "nav-wrapper"
            ]
            [ toggleSidenavButton
            , a [ class "brand-logo center", href "#quests" ]
                [ i [ class "fa fa-shield-alt" ] []
                , span [] [ text "QUEST" ]
                ]
            , ul [ class "hide-on-small-only" ] (navs model)
            ]
        ]


toggleSidenavButton : Html LayoutMsg
toggleSidenavButton =
    a
        [ href "javascript:void(0);"
        , class "left sidenav-trigger hide-on-med-and-up"
        , onClick ToggleSidenav
        , css
            [ cursor pointer
            ]
        ]
        [ i [ class "material-icons" ] [ text "menu" ]
        ]


sideNavtransform isOpen =
    if isOpen then
        "translateX(0%)"
    else
        "translateX(-105%)"


layout : Model -> Html Msg -> Html Msg
layout model view =
    div
        []
        [ Html.Styled.map Layout (navbar model)
        , Html.Styled.map Layout
            (ul
                [ id "slide-out"
                , class "sidenav"
                , onClick ToggleSidenav
                , style
                    [ ( "transform", sideNavtransform model.layout.sidenavOpen )
                    , ( "transition", ".25s" )
                    ]
                ]
                (navs model)
            )
        , view
        ]
