module Component.QuestCard exposing (..)

import Html
import Theme
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Types exposing (RecentPostedQuest)


questCardBase quest params =
    div
        [ css
            [ maxWidth (px 320)
            , margin (px 16)
            ]
        ]
        [ div [ class "card" ]
            [ div [ class "card-image" ]
                ([ img
                    [ src quest.imageUrl
                    ]
                    []
                 , div
                    [ class "card-title"
                    , style [ ( "padding", "8px 8px 24px 8px" ) ]
                    , css
                        [ backgroundColor (rgba 255 255 255 0.7)
                        , Css.left (px 0)
                        , Css.right (px 0)
                        , Css.bottom (px 0)
                        ]
                    ]
                    [ h5 [ css [ color Theme.baseTextColor, margin (px 0) ] ] [ text quest.name ]
                    ]
                 ]
                    ++ (if params.showUserImage then
                            [ div
                                [ css
                                    [ position Css.absolute
                                    , top (px 0)
                                    , left (px 0)
                                    , Css.height (px 50)
                                    , Css.width (px 50)
                                    ]
                                ]
                                [ img [ src ("https://graph.facebook.com/" ++ quest.userId ++ "/picture?type=small") ] []
                                ]
                            ]
                        else
                            []
                       )
                )
            , div [ class "card-content" ]
                [ text quest.description ]
            , (case params.actionSection of
                Just actionSection ->
                    div
                        [ css
                            [ padding (px 0)
                            ]
                        ]
                        [ actionSection ]

                Nothing ->
                    div [] []
              )
            ]
        ]


questCardWithActionSection quest params =
    questCardBase quest
        { showUserImage = params.showUserImage
        , actionSection = Just params.actionSection
        }


questCard quest params =
    questCardBase quest
        { showUserImage = params.showUserImage
        , actionSection = Nothing
        }
