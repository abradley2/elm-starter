module Update.ArmiesUpdate exposing (armiesModel, armiesUpdate, ArmiesModel)

import Message exposing (Message, Message(..))
import Message.ArmiesMessage exposing (ArmiesMessage(..))


type alias ArmiesModel =
    { armyList : List String
    , newArmyName : String
    }


armiesModel : ArmiesModel
armiesModel =
    { armyList = []
    , newArmyName = ""
    }


onArmiesMessage : ArmiesMessage -> ArmiesModel -> List (Cmd Message) -> ( ArmiesModel, List (Cmd Message) )
onArmiesMessage armiesMessage armies commands =
    case armiesMessage of
        EditNewArmyName newArmyName ->
            ( { armies | newArmyName = newArmyName }, commands )

        AddNewArmy ->
            ( { armies
                | armyList = armiesModel.armyList ++ [ armiesModel.newArmyName ]
                , newArmyName = ""
              }
            , commands
            )

        GetArmiesResult (Result.Ok armyList) ->
            ( { armies | armyList = armyList }, commands )

        GetArmiesResult (Result.Err _) ->
            ( armies, commands )

        NoOp ->
            ( armies, commands )


armiesUpdate : Message -> ArmiesModel -> List (Cmd Message) -> ( ArmiesModel, List (Cmd Message) )
armiesUpdate message armies commands =
    case message of
        Armies armiesMessage ->
            onArmiesMessage armiesMessage armies commands

        _ ->
            ( armies, commands )
