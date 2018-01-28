module View.CreateQuestView exposing (createQuestView)

import Html
import Array
import Theme
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.CreateQuestMessage exposing (CreateQuestMessage, CreateQuestMessage(..))
import Component.TextField exposing (textField)
import Component.TextArea exposing (textArea)
import Component.Modal exposing (modal)
import Component.FileInput exposing (fileInput)
import Component.RaisedButton exposing (raisedButton)
import Component.FlatButton exposing (flatButton)


helperText =
    """
THY QUEST (if you choose too acept it) IS
"""


card questStep onEditName onEditDescription onClickImageUpload =
    div
        [ css
            [ maxWidth (px 320) ]
        ]
        [ div [ class "card" ]
            [ div [ class "card-image" ]
                [ img [ src questStep.imageUrl ] []
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
                    [ h5 [ css [ color Theme.baseTextColor, margin (px 0) ] ] [ text questStep.name ]
                    ]
                , a
                    [ class "btn-floating halfway-fab waves-effect waves-light red"
                    , onClick (onClickImageUpload questStep.id)
                    ]
                    [ i [ class "material-icons" ] [ text "add_a_photo" ]
                    ]
                ]
            , div [ class "card-content" ]
                [ textField
                    { id = "name-textfield" ++ questStep.id
                    , value = questStep.name
                    , onInput = onEditName
                    , label = "Quest Name"
                    , class = Nothing
                    }
                , textArea
                    { id = "description-textarea" ++ questStep.id
                    , value = questStep.description
                    , label = "Quest Description"
                    , class = Nothing
                    , onInput = onEditDescription
                    }
                ]
            ]
        ]


createQuestView : Model -> Html CreateQuestMessage
createQuestView model =
    div []
        [ div []
            [ modal
                { open = model.createQuest.imageUploadModalOpen
                , id = Maybe.withDefault "" model.createQuest.imageUploadModalFor
                , content =
                    div []
                        [ p [ class "float-text" ] [ text "Upload a picture that describes this adventure" ]
                        , div [ class "row" ]
                            [ (fileInput
                                { id = "image-upload"
                                , label = "Image (max size 2mb)"
                                , onChange = OnFileChosen
                                , value = Maybe.withDefault "" model.createQuest.imageUploadPath
                                }
                              )
                            ]
                        , div [ class "row" ]
                            [ flatButton
                                { label = "Cancel"
                                , onClick = HideFileUploadModal
                                }
                            , case model.createQuest.imageUploadPath of
                                Just validpath ->
                                    raisedButton
                                        { label = "Upload"
                                        , icon = Just "file_upload"
                                        , onClick = ConfirmFileUpload "image-upload"
                                        }

                                Nothing ->
                                    div [] []
                            ]
                        ]
                , footer = div [] []
                , noop = NoOp
                , onRequestClose = HideFileUploadModal
                }
            ]
        , div
            [ class "container" ]
            [ div [ css [ textAlign center ] ]
                [ p [ class "flow-text" ]
                    [ (text helperText)
                    ]
                ]
            , div [ class "row" ]
                [ div [ css [ margin auto, maxWidth (px 320) ] ]
                    [ (card
                        { id = model.createQuest.id
                        , name = model.createQuest.questName
                        , description = model.createQuest.questDescription
                        , imageUrl = model.createQuest.questImageUrl
                        }
                        (EditQuestName)
                        (EditQuestDescription)
                        (ShowFileUploadModal)
                      )
                    ]
                ]
            , div [ class "row" ]
                [ div
                    [ css
                        [ displayFlex
                        , flexWrap Css.wrap
                        ]
                    ]
                    (List.map
                        (\questStep ->
                            (card
                                questStep
                                (EditQuestStepName questStep.id)
                                (EditQuestStepDescription questStep.id)
                                (ShowFileUploadModal)
                            )
                        )
                        (Array.toList model.createQuest.questSteps)
                    )
                ]
            ]
        ]
