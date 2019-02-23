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
import Html exposing (Html, Attribute, div, input, text, ol, li, button, h1)
import Html.Attributes exposing (value, placeholder, class, size)
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
  , cued : Item
  }


init : Model
init =
    { content = []
    , cued = ""
    }


---- UPDATE

type Msg
    = AddCued
    | Cue Item
    | Reset
    | RemoveNewest


update : Msg -> Model -> Model
update msg model =

    case msg of

        AddCued ->
            {model | content = updateCopy model, cued = ""}

        Cue item ->
            {model | cued = item}

        RemoveNewest ->
            {model | content = removeLatest model, cued = ""}

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
            List.drop 1 model.content


updateCopy : Model -> Content
updateCopy model =
--    List.append model.content [model.cued]
    (::) model.cued model.content


---- VIEW


renderLine : Item -> (Html msg)
renderLine item =
    li [class "list-group-item  list-group-item-dark"] [text item]


renderContent : Content -> List (Html msg)
renderContent list =
    List.map renderLine list


view: Model -> Html Msg
view model =
  div [class "container container-2"] [

    div [class "group-box"] [

        div [class "row"] [
            div [class "col-md-12"] [
                h1 [ ] [text "To-Do List"]
            ]
        ]

        ,div [class "row"] [
            div [class "col-md-12"] [
                div [class "btn-group"] [
                    button [onClick AddCued, class "btn btn-primary"] [text "Add"]
                    , button [onClick RemoveNewest, class "btn btn-secondary"] [text "Undo"]
                    , button [onClick Reset,  class "btn btn-danger"] [text "Reset"]
                ]
            ]
        ]

        ,div [class "row"] [
            div [class "col-md-12"] [
                input [class "new-todo", size 40, value model.cued, onInput Cue, placeholder "Todo Item"] []
            ]
        ]

        ,div [class "row"] [
            div [class "col-md-12"] [
                ol [] (renderContent model.content)
            ]
        ]
    ]

  ]



