module Request.QuestsRequest exposing (getQuests, getQuestsByUser, getSideQuests, suggestSideQuest, getQuestDetails)

import Http
import Message.SideQuestsMessage exposing (SideQuestsMessage, SideQuestsMessage(..))
import Message.QuestsMessage exposing (QuestsMessage(..), QuestsMessage)
import Message.MyAdventurerMessage exposing (MyAdventurerMessage(..), MyAdventurerMessage)
import Message.QuestDetailsMessage exposing (QuestDetailsMessage(..), QuestDetailsMessage)
import Json.Decode exposing (..)
import Json.Encode as Encode
import Types exposing (RecentPostedQuest, SideQuest, GetSideQuestsResponse, QuestDetailsResponse)


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
    Json.Decode.map4 SideQuest
        (field "name" string)
        (field "id" string)
        (field "guid" string)
        (field "suggestedBy" string)


decodeQuestDetails =
    Json.Decode.map3 QuestDetailsResponse
        (field "quests" decodeQuest)
        (field "sideQuests" (Json.Decode.list decodeSideQuest))
        (field "suggestedSideQuests" (Json.Decode.list decodeSideQuest))


encodeSideQuest sideQuest =
    Encode.object
        [ ( "name", Encode.string sideQuest.name )
        , ( "description", Encode.string sideQuest.description )
        ]


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


getQuestDetails : String -> String -> String -> String -> Cmd QuestDetailsMessage
getQuestDetails apiEndpoint userToken userId questId =
    let
        request =
            Http.request
                { method = "GET"
                , headers =
                    [ Http.header "Authorization" ("Bearer " ++ userToken)
                    ]
                , url = (apiEndpoint ++ "quests/details/" ++ userId ++ "/" ++ questId)
                , body = Http.emptyBody
                , expect = Http.expectJson decodeQuestDetails
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send GetQuestDetailsResult request


suggestSideQuest : String -> String -> RecentPostedQuest -> SideQuest -> Cmd SideQuestsMessage
suggestSideQuest apiEndpoint userToken quest sideQuest =
    let
        request =
            Http.request
                { method = "POST"
                , headers =
                    [ Http.header "Authorization" ("Bearer " ++ userToken)
                    ]
                , url = (apiEndpoint ++ "sidequests/" ++ quest.userId ++ "/" ++ quest.guid)
                , body = Http.jsonBody (encodeSideQuest sideQuest)
                , expect = Http.expectJson (Json.Decode.field "success" bool)
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send SuggestSideQuestResult request
