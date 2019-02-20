
module Main exposing (main)

import Browser
import Html exposing (Html, Attribute, div, input, text, br, ol, li, button)
import Html.Attributes exposing (value, placeholder)
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

type alias Content = List String

type alias Model =
  { content : Content
  , newItem : Item
  }


init : Model
init =
    { content = []
    , newItem = ""
    }


---- UPDATE

type Msg
    = Add
    | CueNew Item
    | Reset
    | RemoveLatest


update : Msg -> Model -> Model
update msg model =

    case msg of

        Add ->
            {model | content = updateCopy model, newItem = ""}

        CueNew item ->
            {model | newItem = item}

        RemoveLatest ->
            {model | content = removeLatest model, newItem = ""}

        Reset ->
            init


hasNoContent : Model -> Bool
hasNoContent model =
    List.length model.content == 0


removeLatest : Model -> Content
removeLatest model =
    if hasNoContent model
        then
            model.content
        else
            List.take (List.length model.content - 1) model.content


updateCopy : Model -> Content
updateCopy model =
    List.append model.content [model.newItem]


renderLine : Item -> (Html msg)
renderLine item =
    li [] [text item]


renderContent : Content -> List (Html msg)
renderContent list =
    List.map renderLine list


view: Model -> Html Msg
view model =
  div []
    [ ol [] (renderContent model.content)
    , br [] []
    , input [value model.newItem, onInput CueNew, placeholder "Item"] []
    , br [] []
    , button [onClick Add] [text "Add"]
    , button [onClick RemoveLatest] [text "Remove Current"]
    , button [onClick Reset] [text "Reset"]
    ]

