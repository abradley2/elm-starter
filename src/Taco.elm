module Taco exposing (Taco, taco, TacoMsg(..), update)


type alias Taco =
    { filling : String }


taco : Taco
taco =
    { filling = "beans" }


type TacoMsg
    = Taco_NoOp


update : TacoMsg -> Taco -> Taco
update msg taco =
    case msg of
        Taco_NoOp ->
            taco
