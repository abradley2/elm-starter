module Request.ArmiesRequest exposing (getArmies)

import Http
import Message.ArmiesMessage exposing (ArmiesMessage(..), ArmiesMessage)
import Json.Decode exposing (..)


decodeArmiesList =
    Json.Decode.list Json.Decode.string


getArmies : String -> Cmd ArmiesMessage
getArmies userToken =
    let
        request =
            Http.request
                { method = "GET"
                , headers =
                    [ Http.header "Authorization" ("Bearer " ++ userToken)
                    ]
                , url = "http://localhost:5000/armies"
                , body = Http.emptyBody
                , expect = Http.expectJson decodeArmiesList
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send GetArmiesResult request
