module Request.SessionRequest exposing (loadSession)

import Types exposing (SessionInfo)
import Http
import Json.Decode exposing (..)


decodeSessionInfo =
    Json.Decode.map2 SessionInfo
        (at [ "username" ] (nullable string))
        (at [ "userId" ] (nullable string))


loadSession : String -> String -> Http.Request SessionInfo
loadSession apiEndpoint queryParams =
    Http.request
        { method = "GET"
        , headers =
            []
        , url = (apiEndpoint ++ "session/load" ++ queryParams)
        , body = Http.emptyBody
        , expect = Http.expectJson decodeSessionInfo
        , timeout = Nothing
        , withCredentials = True
        }
