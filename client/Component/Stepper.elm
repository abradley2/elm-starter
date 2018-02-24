module Component.Stepper exposing (stepper)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Theme


stepper params =
    div []
        (List.indexedMap
            (\idx step ->
                div
                    [ css
                        [ maxWidth (px 300)
                        , Css.pseudoClass "not(:first-child)" [ marginTop (px 12) ]
                        ]
                    ]
                    [ div
                        [ css
                            [ displayFlex
                            , alignItems center
                            ]
                        ]
                        [ span
                            [ css
                                [ display inlineBlock
                                , Css.width (px 25)
                                , Css.height (px 25)
                                , borderRadius (pct 50)
                                , backgroundColor Theme.accentColor
                                , lineHeight (px 25)
                                , color Theme.white
                                , fontWeight (int 500)
                                , textAlign Css.center
                                ]
                            ]
                            [ text (toString (idx + 1))
                            ]
                        , span
                            [ css
                                [ paddingLeft (px 8)
                                , fontWeight (int 500)
                                , fontSize (px 16)
                                ]
                            ]
                            [ text step.title ]
                        ]
                    , div
                        [ css
                            [ borderLeft3 (px 1) Css.solid Theme.accentColor
                            , marginLeft (px 12)
                            , marginTop (px 12)
                            , paddingLeft (px 13)
                            ]
                        ]
                        [ text step.description
                        ]
                    ]
            )
            params.steps
        )
