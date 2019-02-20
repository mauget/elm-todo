
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

type alias Contents = String

type alias Model =
  { content : Contents
  , newItem : Item
  }


init : Model
init =
    { content = ""
    , newItem = ""
    }


---- UPDATE

type Msg
    = Add
    | Reset
    | RemovePrev
    | SetNew String


update : Msg -> Model -> Model
update msg model =

    case msg of

        Add ->
            {model | content = updatedCopy model, newItem = ""}

        SetNew arg ->
            {model | newItem = arg}

        RemovePrev ->
            {model | content = rightTrimmedCopy model, newItem = ""}

        Reset ->
            init


updatedCopy : Model -> Contents
updatedCopy m =
    if m.newItem == ""
        then m.content
        else m.content ++ "\n" ++ m.newItem


rightTrimmedCopy : Model -> Contents
rightTrimmedCopy model =
    let
        lista = String.lines model.content
        listb = appendNewLines lista
    in
    String.concat listb


appendNewLines : (List a) -> (List a)
appendNewLines list =
    if List.isEmpty list then list else List.take ((List.length list) - 1) list
    |> List.filter (\v -> (String.length v) > 0)
    |> List.map (\v -> v ++ "\n" )

-- VIEW

view: Model -> Html Msg
view model =

  div []
    [ textarea [rows 10, cols 40, disabled True ] [text model.content]
    , br [] []
    , input [value model.newItem, onInput SetNew,  placeholder "Item"] []
    , br [] []
    , button [onClick Add] [text "Add"]
    , button [onClick RemovePrev] [text "Remove Prev"]
    , button [onClick Reset] [text "Reset"]
    ]
