{-
Copyright (c) 2019 Lou Mauget, mauget@gmail.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-}


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


---- VIEW


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

