module Request.SessionRequest exposing (loadSession)

import Types exposing (SessionInfo)
import Http
import Json.Decode exposing (..)


decodeSessionInfo =
    Json.Decode.map2 SessionInfo
        (at [ "username" ] string)
        (at [ "userId" ] string)


loadSession : String -> String -> Http.Request SessionInfo
loadSession apiEndpoint userToken =
    Http.request
        { method = "GET"
        , headers =
            [ Http.header "Authorization" ("Bearer " ++ userToken)
            ]
        , url = (apiEndpoint ++ "session/load")
        , body = Http.emptyBody
        , expect = Http.expectJson decodeSessionInfo
        , timeout = Nothing
        , withCredentials = False
        }
