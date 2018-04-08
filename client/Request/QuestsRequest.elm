module Request.QuestsRequest
    exposing
        ( decideSideQuest
        , getQuests
        , getQuestsByUser
        , getSideQuests
        , suggestSideQuest
        , getQuestDetails
        )

import Http
import Json.Decode exposing (..)
import Json.Encode as Encode
import Types exposing (RecentPostedQuest, SideQuest, GetSideQuestsResponse, QuestDetailsResponse)


decodeQuestsList =
    Json.Decode.list decodeQuest


decodeSideQuest =
    Json.Decode.map5 SideQuest
        (field "name" string)
        (field "description" string)
        (field "guid" string)
        (field "suggestedBy" string)
        (field "id" string)


decodeSideQuestsList =
    Json.Decode.list decodeSideQuest


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


decodeQuestDetails =
    Json.Decode.map3 QuestDetailsResponse
        (field "quest" decodeQuest)
        (field "sideQuests" (Json.Decode.list decodeSideQuest))
        (field "suggestedSideQuests" (Json.Decode.list decodeSideQuest))


encodeSideQuest sideQuest =
    Encode.object
        [ ( "name", Encode.string sideQuest.name )
        , ( "description", Encode.string sideQuest.description )
        ]


decodeGetSideQuestsResponse =
    Json.Decode.map2 GetSideQuestsResponse
        (field "quest" decodeQuest)
        (field "sideQuests" decodeSideQuestsList)


getQuests : String -> Http.Request (List RecentPostedQuest)
getQuests apiEndpoint =
    Http.request
        { method = "GET"
        , headers =
            []
        , url = apiEndpoint ++ "quests"
        , body = Http.emptyBody
        , expect = Http.expectJson decodeQuestsList
        , timeout = Nothing
        , withCredentials = True
        }


getSideQuests : String -> String -> String -> Http.Request GetSideQuestsResponse
getSideQuests apiEndpoint userId questId =
    Http.request
        { method = "GET"
        , headers =
            []
        , url = (apiEndpoint ++ "sidequests/" ++ userId ++ "?questId=" ++ questId)
        , body = Http.emptyBody
        , expect = Http.expectJson decodeGetSideQuestsResponse
        , timeout = Nothing
        , withCredentials = True
        }


getQuestsByUser : String -> String -> Http.Request (List RecentPostedQuest)
getQuestsByUser apiEndpoint userId =
    Http.request
        { method = "GET"
        , headers =
            []
        , url = (apiEndpoint ++ "quests/" ++ userId)
        , body = Http.emptyBody
        , expect = Http.expectJson decodeQuestsList
        , timeout = Nothing
        , withCredentials = True
        }


getQuestDetails : String -> String -> String -> Http.Request QuestDetailsResponse
getQuestDetails apiEndpoint userId questId =
    Http.request
        { method = "GET"
        , headers =
            []
        , url = (apiEndpoint ++ "quests/details/" ++ userId ++ "/" ++ questId)
        , body = Http.emptyBody
        , expect = Http.expectJson decodeQuestDetails
        , timeout = Nothing
        , withCredentials = True
        }


type alias DecideSideQuestParams =
    { apiEndpoint : String
    , questId : String
    , sideQuestId : String
    , isAccepted : Bool
    }


decideSideQuest : DecideSideQuestParams -> Http.Request QuestDetailsResponse
decideSideQuest params =
    Http.request
        { method = "PUT"
        , headers =
            []
        , url = (params.apiEndpoint ++ "quests/" ++ params.questId ++ "/decidesidequest")
        , body =
            Http.jsonBody
                (Encode.object
                    [ ( "sideQuestId", Encode.string params.sideQuestId )
                    , ( "isAccepted", Encode.bool params.isAccepted )
                    ]
                )
        , expect = Http.expectJson decodeQuestDetails
        , timeout = Nothing
        , withCredentials = True
        }


suggestSideQuest : String -> RecentPostedQuest -> SideQuest -> Http.Request Bool
suggestSideQuest apiEndpoint quest sideQuest =
    Http.request
        { method = "POST"
        , headers =
            []
        , url = (apiEndpoint ++ "sidequests/" ++ quest.userId ++ "/" ++ quest.id)
        , body = Http.jsonBody (encodeSideQuest sideQuest)
        , expect = Http.expectJson (Json.Decode.field "success" bool)
        , timeout = Nothing
        , withCredentials = True
        }
