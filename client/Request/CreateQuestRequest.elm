module Request.CreateQuestRequest exposing (createQuestRequest)

import Http
import Json.Decode exposing (..)
import Json.Encode
import Types exposing (Quest)


decodeQuest =
    Json.Decode.map4 Quest
        (Json.Decode.at [ "id" ] Json.Decode.string)
        (Json.Decode.at [ "name" ] Json.Decode.string)
        (Json.Decode.at [ "description" ] Json.Decode.string)
        (Json.Decode.at [ "imageUrl" ] Json.Decode.string)


encodeQuest : Quest -> Json.Encode.Value
encodeQuest quest =
    Json.Encode.object
        [ ( "id", Json.Encode.string quest.id )
        , ( "name", Json.Encode.string quest.name )
        , ( "description", Json.Encode.string quest.description )
        , ( "imageUrl", Json.Encode.string quest.imageUrl )
        ]


createQuestRequest : String -> Quest -> Http.Request Quest
createQuestRequest apiEndpoint quest =
    Http.request
        { method = "POST"
        , headers =
            []
        , url = apiEndpoint ++ "quests"
        , body = Http.jsonBody <| (encodeQuest quest)
        , expect = Http.expectJson decodeQuest
        , timeout = Nothing
        , withCredentials = True
        }
