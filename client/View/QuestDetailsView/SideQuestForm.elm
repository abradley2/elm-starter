module View.QuestDetailsView.SideQuestForm exposing (sideQuestForm)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Update.QuestDetailsUpdate exposing (QuestDetailsMsg, QuestDetailsMsg(..))
import Component.TextField exposing (textField)
import Component.TextArea exposing (textArea)
import Component.RaisedButton exposing (raisedButton)
import Component.FlatButton exposing (flatButton)
import Theme


type alias FormParams =
    { name : String
    , description : String
    , open : Bool
    , submitting : Bool
    }


sideQuestForm : FormParams -> Html QuestDetailsMsg
sideQuestForm formParams =
    div
        [ css
            [ position absolute
            , zIndex (int 100)
            , backgroundColor Theme.white
            , left (px 0)
            , right (px 0)
            , overflow Css.hidden
            , padding
                (px
                    (if formParams.open then
                        16
                     else
                        0
                    )
                )
            , Css.height
                (if formParams.open then
                    (px 400)
                 else
                    (px 0)
                )
            ]
        , style [ ( "transition", ".3s" ), ( "box-shadow", Theme.cardBoxShadow ) ]
        ]
        [ div []
            [ div []
                [ p [ class "flow-text" ]
                    [ text "What Side Quest would help this adventurer by its completion?" ]
                ]
            , textField
                { id = "sidequestform-textfield"
                , value = formParams.name
                , onInput = EditSideQuestName
                , label = "Side Quest Name"
                , class = Nothing
                }
            , textArea
                { id = "sidequestform-textarea"
                , value = formParams.description
                , label = "Side Quest Description"
                , class = Nothing
                , onInput = EditSideQuestDescription
                }
            , div
                [ css
                    [ displayFlex
                    , justifyContent center
                    ]
                ]
                [ (flatButton
                    { onClick = HideSideQuestForm
                    , label = "Close"
                    }
                  )
                , (let
                    canSubmit =
                        List.all (\isTrue -> isTrue)
                            [ formParams.description /= ""
                            , formParams.name /= ""
                            ]
                   in
                    raisedButton
                        { disabled = List.any (\v -> v) [ not canSubmit, formParams.submitting ]
                        , label =
                            if canSubmit then
                                (if formParams.submitting then
                                    "Loading"
                                 else
                                    "Submit!"
                                )
                            else
                                "Add details"
                        , onClick = SubmitSideQuestForm
                        , icon = Nothing
                        }
                  )
                ]
            ]
        ]
