module Update.QuestsUpdate exposing (questsModel, questsUpdate, QuestsModel)

import Message exposing (Message, Message(..))
import Message.QuestsMessage exposing (QuestsMessage(..))


type alias QuestsModel =
    { armyList : List String
    , newQuestName : String
    }


questsModel : QuestsModel
questsModel =
    { armyList = []
    , newQuestName = ""
    }


onQuestsMessage : QuestsMessage -> QuestsModel -> List (Cmd Message) -> ( QuestsModel, List (Cmd Message) )
onQuestsMessage armiesMessage quests commands =
    case armiesMessage of
        EditNewArmyName newQuestName ->
            ( { quests | newQuestName = newQuestName }, commands )

        AddNewArmy ->
            ( { quests
                | armyList = questsModel.armyList ++ [ questsModel.newQuestName ]
                , newQuestName = ""
              }
            , commands
            )

        GetArmiesResult (Result.Ok armyList) ->
            ( { quests | armyList = armyList }, commands )

        GetArmiesResult (Result.Err _) ->
            ( quests, commands )

        NoOp ->
            ( quests, commands )


questsUpdate : Message -> QuestsModel -> List (Cmd Message) -> ( QuestsModel, List (Cmd Message) )
questsUpdate message quests commands =
    case message of
        Armies armiesMessage ->
            onQuestsMessage armiesMessage quests commands

        _ ->
            ( quests, commands )
