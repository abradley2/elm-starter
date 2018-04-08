port module Ports exposing (..)


port uploadQuestImage : String -> Cmd msg


port uploadQuestImageFinished : (( Bool, String ) -> msg) -> Sub msg


port navigate : (String -> msg) -> Sub msg
