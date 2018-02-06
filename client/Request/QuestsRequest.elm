module Request.QuestsRequest exposing (getQuests, getQuestsByUser)

import Http
import Message.QuestsMessage exposing (QuestsMessage(..), QuestsMessage)
import Message.MyAdventurerMessage exposing (MyAdventurerMessage(..), MyAdventurerMessage)
import Json.Decode exposing (..)
import Types exposing (RecentPostedQuest)


decodeQuest =
    Json.Decode.map8 RecentPostedQuest
        (field "name" string)
        (field "description" string)
        (field "imageUrl" string)
        (field "id" string)
        (field "guid" string)
        (field "username" string)
        (field "userId" string)
        (field "upvotes" int)


decodeQuestsList =
    Json.Decode.list decodeQuest


getQuests : String -> String -> Cmd QuestsMessage
getQuests apiEndpoint userToken =
    let
        request =
            Http.request
                { method = "GET"
                , headers =
                    [ Http.header "Authorization" ("Bearer " ++ userToken)
                    ]
                , url = apiEndpoint ++ "quests"
                , body = Http.emptyBody
                , expect = Http.expectJson decodeQuestsList
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send GetQuestsResult request


getQuestsByUser : String -> String -> String -> Cmd MyAdventurerMessage
getQuestsByUser apiEndpoint userToken userId =
    let
        request =
            Http.request
                { method = "GET"
                , headers =
                    [ Http.header "Authorization" ("Bearer " ++ userToken)
                    ]
                , url = (apiEndpoint ++ "quests/" ++ userId)
                , body = Http.emptyBody
                , expect = Http.expectJson decodeQuestsList
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send GetQuestsByUserResult request
