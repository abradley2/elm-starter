port module Ports exposing (..)


port mount : (( String, String ) -> msg) -> Sub msg


port unmount : (( String, String ) -> msg) -> Sub msg


port loadQuestStepId : (( String, String ) -> msg) -> Sub msg


port loadToken : (String -> msg) -> Sub msg


port loadQuestId : (String -> msg) -> Sub msg


port requestQuestStepId : String -> Cmd msg


port requestQuestId : String -> Cmd msg


port uploadQuestImage : String -> Cmd msg


port uploadQuestImageFinished : (( Bool, String ) -> msg) -> Sub msg
