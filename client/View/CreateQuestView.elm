module View.CreateQuestView exposing (createQuestView)

import Html
import Array
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


helperText =
    """
Short description of what a quest is.
"""


card questStep onEditName onEditDescription onClickImageUpload =
    div [ class "col s10 m6 l5" ]
        [ div [ class "card" ]
            [ div [ class "card-image" ]
                [ img [ src questStep.imageUrl ] []
                , div [ class "card-title" ]
                    [ textField
                        { id = "name-textfield" ++ questStep.id
                        , value = questStep.name
                        , onInput = onEditName
                        , label = "Quest Name"
                        , class = Nothing
                        }
                    ]
                , a
                    [ class "btn-floating halfway-fab waves-effect waves-light red"
                    , onClick (onClickImageUpload questStep.id)
                    ]
                    [ i [ class "material-icons" ] [ text "file_upload" ]
                    ]
                ]
            , div [ class "card-content" ]
                [ textArea
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
                , id = model.createQuest.imageUploadModalFor
                , content =
                    div []
                        [ p [ class "float-text" ] [ text "Upload a picture that describes this adventure" ]
                        , div [ class "row" ]
                            [ (fileInput
                                { id = "image-upload"
                                , label = "Image (max size 2mb)"
                                , onChange = OnFileChosen
                                , value = model.createQuest.imageUploadPath
                                }
                              )
                            ]
                        ]
                , footer = div [] []
                , noop = NoOp
                , onRequestClose = HideFileUploadModal
                }
            ]
        , div
            [ class "container" ]
            [ div []
                [ p [ class "flow-text" ]
                    [ (text helperText)
                    ]
                ]
            , div [ class "row" ]
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
            , div [ class "row" ]
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
