module Request.SessionRequest exposing (loadSession)

import Types
import Http
import Msg.SessionMsg exposing (SessionMsg(..), SessionMsg)
import Json.Decode exposing (..)


decodeSessionInfo =
    Json.Decode.map2 Types.SessionInfo
        (at [ "username" ] string)
        (at [ "userId" ] string)


loadSession : String -> String -> Cmd SessionMsg
loadSession apiEndpoint userToken =
    let
        request =
            Http.request
                { method = "GET"
                , headers =
                    [ Http.header "Authorization" ("Bearer " ++ userToken)
                    ]
                , url = (apiEndpoint ++ "taco/load")
                , body = Http.emptyBody
                , expect = Http.expectJson decodeSessionInfo
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send LoadSessionResult request
