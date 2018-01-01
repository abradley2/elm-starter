module Request.ArmiesRequest exposing (getArmies)

import Http
import Message.ArmiesMessage
import Json.Decode exposing (..)


decodeArmiesList =
    Json.Decode.list Json.Decode.string


getArmies userId =
    let
        request =
            Http.request
                { method = "GET"
                , headers =
                    [ ( "Authorization", "Bearer eyJhbGciOiJIUzUxM...kv6TGw7H1GX2g" )
                    ]
                , url = "localhost:5000/armies"
                , body = Http.emptyBody
                , expect = Http.expectJson decodeArmiesList
                , timeout = Nothing
                , withCredentials = False
                }
    in
        Http.send GetArmiesResult request
