module View.Layout exposing (layout)

import Css exposing (..)
import Css.Colors
import Http
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Types exposing (Taco)
import Update.LayoutUpdate exposing (LayoutMsg, LayoutMsg(..), LayoutModel)
import Component.TextField exposing (textField)


navs : LayoutModel -> Taco -> List (Html LayoutMsg)
navs model taco =
    [ li []
        [ a [ href "/quests", attribute "data-link" "/quests" ] [ text "Quests" ]
        ]
    , li []
        [ if taco.userId /= Nothing then
            a [ href "/profile", attribute "data-link" "/profile" ] [ text "My Adventurer" ]
          else
            let
                ( route, location ) =
                    taco.routeData
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


navbar : LayoutModel -> Taco -> Html LayoutMsg
navbar model taco =
    nav []
        [ div
            [ class "nav-wrapper"
            ]
            [ toggleSidenavButton
            , a [ class "brand-logo center", href "#quests" ]
                [ i [ class "fa fa-shield-alt" ] []
                , span [] [ text "QUEST" ]
                ]
            , ul [ class "hide-on-small-only" ] (navs model taco)
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


layout messageMap model taco view =
    div
        []
        [ Html.Styled.map messageMap (navbar model taco)
        , (Html.Styled.map messageMap
            (ul
                [ id "slide-out"
                , class "sidenav"
                , onClick ToggleSidenav
                , style
                    [ ( "transform", sideNavtransform model.sidenavOpen )
                    , ( "transition", ".25s" )
                    ]
                ]
                (navs model taco)
            )
          )
        , view
        ]
