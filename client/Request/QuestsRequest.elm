module Request.QuestsRequest exposing (getQuests)

import Http
import Message.QuestsMessage exposing (QuestsMessage(..), QuestsMessage)
import Json.Decode exposing (..)


decodeQuestsList =
    Json.Decode.list Json.Decode.string


getQuests : String -> Cmd QuestsMessage
getQuests userToken =
    let
        request =
            Http.request
                { method = "GET"
                , headers =
                    [ Http.header "Authorization" ("Bearer " ++ userToken)
                    ]
                , url = "http://localhost:5000/quests"
                , body = Http.emptyBody
                , expect = Http.expectJson decodeQuestsList
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send GetQuestsResult request
