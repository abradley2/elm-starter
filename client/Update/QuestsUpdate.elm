module Update.QuestsUpdate exposing (questsModel, questsUpdate, QuestsModel)

import Update.ComponentsUpdate exposing (components, componentsUpdate, Components)
import Message exposing (Message, Message(..))
import Message.QuestsMessage exposing (QuestsMessage, QuestsMessage(..))


type alias QuestsModel =
    { questList : List String
    , newQuestName : String
    , components : Components
    }


questsModel : QuestsModel
questsModel =
    { questList = []
    , newQuestName = ""
    , components = components
    }


onQuestsMessage : QuestsMessage -> QuestsModel -> List (Cmd Message) -> ( QuestsModel, List (Cmd Message) )
onQuestsMessage questsMessage quests commands =
    case questsMessage of
        EditNewQuestName newQuestName ->
            ( { quests | newQuestName = newQuestName }, commands )

        AddNewQuest ->
            ( { quests
                | questList = quests.questList ++ [ quests.newQuestName ]
                , newQuestName = ""
              }
            , commands
            )

        GetQuestsResult (Result.Ok questList) ->
            ( { quests | questList = questList }, commands )

        GetQuestsResult (Result.Err _) ->
            ( quests, commands )

        NoOp ->
            ( quests, commands )


questsUpdate : Message -> QuestsModel -> List (Cmd Message) -> ( QuestsModel, List (Cmd Message) )
questsUpdate =
    componentsUpdate
        (\message quests commands ->
            case message of
                Quests questsMessage ->
                    onQuestsMessage questsMessage quests commands

                _ ->
                    ( quests, commands )
        )
