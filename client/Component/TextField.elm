module Component.TextField exposing (textField)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)


{-
   <div class="input-field col s6">
             <input id="last_name" type="text" class="validate">
             <label for="last_name">Last Name</label>
           </div>
-}


textField params =
    div
        [ class "input-field " ++ (Maybe.withDefault "" params.class)
        ]
        [ input
            [ id params.id
            , value params.value
            , onInput params.onInput
            , type_ "text"
            ]
            []
        , label
            [ for params.id
            ]
            [ text params.label ]
        ]
