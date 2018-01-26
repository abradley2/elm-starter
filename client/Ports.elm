port module Ports exposing (..)


port mount : (( String, String ) -> message) -> Sub message


port unmount : (( String, String ) -> message) -> Sub message


port loadQuestStepImage : (( String, String ) -> message) -> Sub message


port loadQuestStepId : (( Int, String ) -> message) -> Sub message


port loadToken : (String -> message) -> Sub message


port requestQuestStepId : Cmd message
