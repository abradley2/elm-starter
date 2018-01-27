module Component.Modal exposing (modal)

import Css exposing (..)
import Html
import Html.Events exposing (onWithOptions)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Json.Decode


type alias ModalParams a =
    { id : String
    , content : Html a
    , footer : Html a
    , open : Bool
    , noop : a
    , onRequestClose : a
    }


modal : ModalParams a -> Html a
modal params =
    div
        [ style [ ( "transition", ".5s" ) ]
        , onClick params.onRequestClose
        , css
            ([ backgroundColor (rgba 0 0 0 0)
             , position fixed
             , top (px 0)
             , right (px 0)
             , left (px 0)
             , zIndex (int 1000)
             ]
                ++ if params.open then
                    [ backgroundColor (rgba 0 0 0 0.67)
                    , bottom (px 0)
                    ]
                   else
                    [ Css.height (px 0)
                    , overflow Css.hidden
                    ]
            )
        ]
        [ div
            [ id ("modal-" ++ params.id)
            , style [ ( "transition", ".25s" ) ]
            , Html.Styled.Events.onWithOptions
                "click"
                { stopPropagation = True
                , preventDefault = False
                }
                (Json.Decode.succeed params.noop)
            , css
                ([ Css.width (px 320)
                 , padding (px 10)
                 , borderRadius (px 3)
                 , margin auto
                 , backgroundColor (hex "fff")
                 , marginTop (Css.pct 0)
                 , opacity (Css.num 0)
                 ]
                    ++ if params.open then
                        [ opacity (Css.num 1)
                        , marginTop (Css.pct 10)
                        ]
                       else
                        []
                )
            ]
            [ div [ class "modal-content" ] [ params.content ]
            , div [ class "modal-footer" ] [ params.footer ]
            ]
        ]
