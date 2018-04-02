port module Ports exposing (..)


port loadToken : (String -> msg) -> Sub msg


port uploadQuestImage : String -> Cmd msg


port uploadQuestImageFinished : (( Bool, String ) -> msg) -> Sub msg
