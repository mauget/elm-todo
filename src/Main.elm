
module Main exposing (main)

import Browser
import Html exposing (Html, Attribute, div, input, text, br, textarea, button)
import Html.Attributes exposing (rows, cols, disabled, value, placeholder)
import Html.Events exposing (onInput, onClick)


-- MAIN

main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }


-- MODEL

type alias Item = String

type alias Model =
  { content : String
  , newItem : String
  }


init : Model
init =
    { content = "<todo list>"
    , newItem = ""
    }


---- UPDATE

type Msg
    = Add
    | Reset
    | SetNew String


update : Msg -> Model -> Model
update msg model =

    case msg of

        Add ->
            let
                m = model
                todos = if m.newItem == ""
                    then m.content
                    else m.content ++ "\n" ++ m.newItem
            in
            {model | content = todos, newItem = ""}

        SetNew arg ->
            {model | newItem = arg}

        Reset ->
            init

--updatedTodos m =
--    if m.newItem == ""
--        then m.content
--        else m.content ++ "\n" ++ m.newItem



-- VIEW

view: Model -> Html Msg
view model =

  div []
    [ textarea [rows 10, cols 40, disabled True ] [text model.content]
    , br [] []
    , input [value model.newItem, onInput SetNew,  placeholder "Item"] []
    , br [] []
    , button [onClick Add] [text "Add"]
    , button [onClick Reset] [text "Reset"]
    ]
