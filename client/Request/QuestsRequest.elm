module Request.QuestsRequest exposing (getQuests, getQuestsByUser, getSideQuests)

import Http
import Message.SideQuestsMessage exposing (SideQuestsMessage, SideQuestsMessage(..))
import Message.QuestsMessage exposing (QuestsMessage(..), QuestsMessage)
import Message.MyAdventurerMessage exposing (MyAdventurerMessage(..), MyAdventurerMessage)
import Json.Decode exposing (..)
import Types exposing (RecentPostedQuest, SideQuest, GetSideQuestsResponse)


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


decodeSideQuest =
    Json.Decode.map3 SideQuest
        (field "name" string)
        (field "id" string)
        (field "guid" string)


decodeSideQuestsList =
    Json.Decode.list decodeSideQuest


decodeGetSideQuestsResponse =
    Json.Decode.map2 GetSideQuestsResponse
        (field "quest" decodeQuest)
        (field "sideQuests" decodeSideQuestsList)


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


getSideQuests : String -> String -> String -> String -> Cmd SideQuestsMessage
getSideQuests apiEndpoint userToken userId questId =
    let
        request =
            Http.request
                { method = "GET"
                , headers =
                    [ Http.header "Authorization" ("Bearer " ++ userToken)
                    ]
                , url = (apiEndpoint ++ "sidequests/" ++ userId ++ "?questId=" ++ questId)
                , body = Http.emptyBody
                , expect = Http.expectJson decodeGetSideQuestsResponse
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send GetSideQuestsResult request


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
