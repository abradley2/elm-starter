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


getQuestsByUser : String -> String -> Cmd MyAdventurerMessage
getQuestsByUser userToken userId =
    let
        request =
            Http.request
                { method = "GET"
                , headers =
                    [ Http.header "Authorization" ("Bearer " ++ userToken)
                    ]
                , url = ("http://localhost:5000/quests/" ++ userId)
                , body = Http.emptyBody
                , expect = Http.expectJson decodeQuestsList
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send GetQuestsByUserResult request
