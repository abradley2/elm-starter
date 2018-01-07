module Update.QuestsUpdate exposing (questsModel, questsUpdate, QuestsModel)

import Message exposing (Message, Message(..))
import Message.QuestsMessage exposing (QuestsMessage, QuestsMessage(..))


type alias QuestsModel =
    { questList : List String
    , newQuestName : String
    }


questsModel : QuestsModel
questsModel =
    { questList = []
    , newQuestName = ""
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
questsUpdate message quests commands =
    case message of
        Quests questsMessage ->
            onQuestsMessage questsMessage quests commands

        _ ->
            ( quests, commands )
