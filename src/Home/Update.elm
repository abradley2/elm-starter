module Home.Update exposing (..)

import Home.Messages exposing (Msg(..))
import Home.Models exposing (HomeModel)
import List exposing (..)


update : Msg -> HomeModel -> ( HomeModel, Cmd Msg )
update message homeModel =
    case message of
        AddPerson name ->
            ({ homeModel
                | newName = "New Person"
                , people = append homeModel.people [{ id = "1", name = name }]
            }, Cmd.none)
        EditNewName name ->
            ({ homeModel | newName = name }, Cmd.none)
        NoOp ->
            ( homeModel, Cmd.none )
