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


getQuests : String -> String -> Http.Request (List RecentPostedQuest)
getQuests apiEndpoint userToken =
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


getSideQuests : String -> String -> String -> String -> Http.Request GetSideQuestsResponse
getSideQuests apiEndpoint userToken userId questId =
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


getQuestsByUser : String -> String -> String -> Http.Request (List RecentPostedQuest)
getQuestsByUser apiEndpoint userToken userId =
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
        , withCredentials = False
        }


type alias DecideSideQuestParams =
    { apiEndpoint : String
    , userToken : String
    , questId : String
    , sideQuestId : String
    , isAccepted : Bool
    }


decideSideQuest : DecideSideQuestParams -> Http.Request QuestDetailsResponse
decideSideQuest params =
    Http.request
        { method = "PUT"
        , headers =
            [ Http.header "Authorization" ("Bearer " ++ params.userToken)
            ]
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
        , withCredentials = False
        }


suggestSideQuest : String -> String -> RecentPostedQuest -> SideQuest -> Http.Request Bool
suggestSideQuest apiEndpoint userToken quest sideQuest =
    Http.request
        { method = "POST"
        , headers =
            [ Http.header "Authorization" ("Bearer " ++ userToken)
            ]
        , url = (apiEndpoint ++ "sidequests/" ++ quest.userId ++ "/" ++ quest.id)
        , body = Http.jsonBody (encodeSideQuest sideQuest)
        , expect = Http.expectJson (Json.Decode.field "success" bool)
        , timeout = Nothing
        , withCredentials = False
        }
