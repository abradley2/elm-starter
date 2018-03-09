module View.QuestDetailsView.SuggestedQuestsList exposing (suggestedQuestsList)

import Html
import Array
import Theme
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Message.QuestDetailsMessage exposing (QuestDetailsMessage, QuestDetailsMessage(..))
import Types exposing (RecentPostedQuest, SideQuest)


suggestedQuestsList : Bool -> List SideQuest -> Html QuestDetailsMessage
suggestedQuestsList isOpen sideQuests =
    div []
        [ a
            [ class "flow-text"
            , onClick (ToggleShowingSuggestedSideQuests (not isOpen))
            , css
                [ cursor pointer
                , display block
                ]
            ]
            [ span
                [ css
                    [ paddingRight (px 12)
                    ]
                ]
                [ i [ class "fa fa-envelope" ] [] ]
            , span [] [ text "Thou hath mail!" ]
            , span
                [ css
                    [ paddingLeft (px 12)
                    , display inlineBlock
                    , transform
                        (rotate
                            (if isOpen then
                                deg 180
                             else
                                deg 0
                            )
                        )
                    ]
                , style [ ( "transition", "1s" ) ]
                ]
                [ i
                    [ class "fa fa-caret-up"
                    ]
                    []
                ]
            ]
        , div
            [ css
                [ position relative
                ]
            ]
            [ div
                [ css
                    [ position absolute
                    , zIndex (int 100)
                    , backgroundColor Theme.white
                    , left (px 0)
                    , right (px 0)
                    , overflow Css.hidden
                    , padding
                        (px
                            (if isOpen then
                                16
                             else
                                0
                            )
                        )
                    , Css.height
                        (if isOpen then
                            (px 400)
                         else
                            (px 0)
                        )
                    ]
                , style [ ( "transition", ".3s" ), ( "box-shadow", Theme.cardBoxShadow ) ]
                ]
                [ ul [ class "collection" ] []
                ]
            ]
        ]



{-
   <ul class="collection">
      <li class="collection-item avatar">
        <img src="images/yuna.jpg" alt="" class="circle">
        <span class="title">Title</span>
        <p>First Line <br>
           Second Line
        </p>
        <a href="#!" class="secondary-content"><i class="material-icons">grade</i></a>
      </li>
-}
