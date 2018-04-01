module View.CreateQuestView.Main exposing (createQuestView)

import Html
import Array
import Theme
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Types exposing (Taco)
import Update.CreateQuestUpdate exposing (CreateQuestModel, CreateQuestMsg, CreateQuestMsg(..))
import Component.TextField exposing (textField)
import Component.TextArea exposing (textArea)
import Component.Modal exposing (modal)
import Component.FileInput exposing (fileInput)
import Component.RaisedButton exposing (raisedButton)
import Component.FlatButton exposing (flatButton)


helperText =
    """
THY QUEST (if you choose to accept it) IS
"""


validQuest : CreateQuestModel -> Bool
validQuest createQuest =
    List.all (\val -> val == True)
        [ (createQuest.questName /= "")
        ]


fileInputId =
    "create-quest-image-upload"


createQuestView : Taco -> CreateQuestModel -> Html CreateQuestMsg
createQuestView taco createQuest =
    div []
        [ div []
            [ modal
                { open = createQuest.imageUploadModalOpen
                , id = Maybe.withDefault "" createQuest.imageUploadModalFor
                , content =
                    div []
                        [ p [ class "float-text" ] [ text "Upload a picture that describes this adventure" ]
                        , div [ class "row" ]
                            [ (fileInput
                                { id = fileInputId
                                , label = "Image (max size 2mb)"
                                , onChange = OnFileChosen
                                , value = Maybe.withDefault "" createQuest.imageUploadPath
                                }
                              )
                            ]
                        , div [ class "row" ]
                            [ flatButton
                                { label = "Cancel"
                                , onClick = HideFileUploadModal
                                }
                            , case createQuest.imageUploadPath of
                                Just validpath ->
                                    raisedButton
                                        { disabled = createQuest.questImageUploadPending
                                        , label = "Upload"
                                        , icon = Just "file_upload"
                                        , onClick = ConfirmFileUpload fileInputId
                                        }

                                Nothing ->
                                    div [] []
                            ]
                        , div [ css [ color Theme.errorTextColor ] ]
                            [ text
                                (if createQuest.questImageUploadError then
                                    "There was an error uploading your image. Please ensure images are less than 2mb"
                                 else
                                    ""
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
            [ div [ css [ textAlign center ] ]
                [ p [ class "flow-text" ]
                    [ (text helperText)
                    ]
                ]
            , div [ class "row" ]
                [ div [ css [ margin auto, maxWidth (px 320) ] ]
                    [ div
                        [ css
                            [ maxWidth (px 320) ]
                        ]
                        [ div [ class "card" ]
                            [ div [ class "card-image" ]
                                [ img [ src createQuest.questImageUrl ] []
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
                                    [ h5 [ css [ color Theme.baseTextColor, margin (px 0) ] ] [ text createQuest.questName ]
                                    ]
                                , a
                                    [ class "btn-floating halfway-fab waves-effect waves-light red"
                                    , onClick (ShowFileUploadModal)
                                    ]
                                    [ i [ class "material-icons" ] [ text "add_a_photo" ]
                                    ]
                                ]
                            , div [ class "card-content" ]
                                [ textField
                                    { id = "name-textfield-createquest"
                                    , value = createQuest.questName
                                    , onInput = EditQuestName
                                    , label = "Quest Name"
                                    , class = Nothing
                                    }
                                , textArea
                                    { id = "description-textarea-createquest"
                                    , value = createQuest.questDescription
                                    , label = "Quest Description"
                                    , class = Nothing
                                    , onInput = EditQuestDescription
                                    }
                                , raisedButton
                                    { label =
                                        if validQuest createQuest then
                                            "embark"
                                        else
                                            "fill in details"
                                    , onClick =
                                        if
                                            List.all
                                                (\v -> v == True)
                                                [ validQuest createQuest, createQuest.submitPending == False ]
                                        then
                                            SubmitCreateQuest
                                        else
                                            NoOp
                                    , icon = Nothing
                                    , disabled =
                                        List.any
                                            (\v -> v == True)
                                            [ validQuest createQuest == False, createQuest.submitPending ]
                                    }
                                , div [ css [ paddingTop (px 8) ] ]
                                    [ span
                                        [ css [ color Theme.errorTextColor ]
                                        ]
                                        [ text
                                            (if createQuest.submitError then
                                                "Oops! was an error creating this quest"
                                             else
                                                ""
                                            )
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
