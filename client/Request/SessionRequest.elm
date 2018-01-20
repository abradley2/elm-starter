module Request.SessionRequest exposing (loadSession)

import Types
import Http
import Message.SessionMessage exposing (SessionMessage(..), SessionMessage)
import Json.Decode exposing (..)


decodeSessionInfo =
    Json.Decode.map2 Types.SessionInfo
        (at [ "username" ] string)
        (at [ "userId" ] string)


loadSession : String -> Cmd SessionMessage
loadSession userToken =
    let
        request =
            Http.request
                { method = "GET"
                , headers =
                    [ Http.header "Authorization" ("Bearer " ++ userToken)
                    ]
                , url = "http://localhost:5000/session/load"
                , body = Http.emptyBody
                , expect = Http.expectJson decodeSessionInfo
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send LoadSessionResult request
