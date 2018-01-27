port module Ports exposing (..)


port mount : (( String, String ) -> message) -> Sub message


port unmount : (( String, String ) -> message) -> Sub message


port loadQuestStepImage : (( String, String ) -> message) -> Sub message


port loadQuestStepId : (( String, String ) -> message) -> Sub message


port loadToken : (String -> message) -> Sub message


port loadQuestId : (String -> message) -> Sub message


port requestQuestStepId : String -> Cmd message


port requestQuestId : String -> Cmd message
