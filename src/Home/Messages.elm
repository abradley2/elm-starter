module Home.Messages exposing (..)


type alias MerryMessage =
    { message : String }


type Msg
    = NoOp
    | EditNewName String
    | AddPerson String
    | GetMessage (Result Http.Error MerryMessage)
