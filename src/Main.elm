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
import Html exposing (Html, Attribute, div, input, text, button, h1, select, option)
import Html.Attributes exposing (id, value, placeholder, class, size, autofocus)
import Html.Events exposing (onClick, onInput)

-- MAIN

main =
  Browser.sandbox { init = init , update = update , view = view }


-- MODEL

type alias Content = List Todo

type alias Seq = Int

type alias TodoText = String

type alias TodoKey = String

type alias Todo = {value: TodoKey, txt: TodoText}

type alias Model =
  { content : Content
  , selected : TodoKey
  , staged : TodoText
  , seq : Seq
  }


init : Model
init =
    { content = []
    , selected = ""
    , staged = ""
    , seq = 100
    }


---- UPDATE

type Msg
    = AddStaged
    | CacheSelected TodoKey
    | RemoveNewest
    | RemoveSelected
    | Reset
    | StageInput TodoText


update : Msg -> Model -> Model
update msg model =

    case msg of

        AddStaged ->
            let
                newSeq = (+) 1 model.seq
                newKey = generateKey newSeq
                newToDo = {value = newKey, txt = model.staged}
                newContent = (::) newToDo model.content
            in
            {model |  seq = newSeq, content = newContent, staged = ""}

        StageInput todoTxt ->
            {model | staged = todoTxt}

        RemoveNewest ->
            {model | content = removeLatest model}

        CacheSelected todoKey ->
            {model | selected = todoKey}

        RemoveSelected ->
            removeSelected model

        Reset ->
            init


hasNoContent : Model -> Bool
hasNoContent model =
    List.isEmpty model.content


removeLatest : Model -> Content
removeLatest model =
    if hasNoContent model
        then
            model.content
        else
            List.drop 1 model.content


removeSelected : Model -> Model
removeSelected  model =
    let
        filterFunc = \todo -> todo.value /= model.selected
        culledList = List.filter filterFunc model.content
    in
    {model | content = culledList, selected = ""}


---- VIEW

renderLine : Todo -> (Html msg)
renderLine todo =
    let
        idVal = todo.value
        todoText = todo.value ++ ": " ++ todo.txt
    in
    option [id idVal, value idVal] [text todoText]


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
                    button [onClick AddStaged, class "btn btn-primary"] [text "Add"]
                    , button [onClick RemoveSelected, class "btn btn-secondary"] [text "Remove Selection"]
                    , button [onClick RemoveNewest, class "btn btn-secondary"] [text "Remove Top"]
                    , button [onClick Reset,  class "btn btn-danger"] [text "Reset"]
                ]
            ]
        ]

        ,div [class "row"] [
            div [class "col-md-12"] [
                input [ onInput StageInput, class "new-todo", size 100, value model.staged,
                    placeholder "New todo item", autofocus True] []
            ]
        ]

        ,div [class "row"] [
            div [class "col-md-12"] [
                select [size 15, onInput CacheSelected] (renderContent model.content)
            ]
        ]

    ]

  ]


-- UTILITY

generateKey : Seq -> TodoKey
generateKey seq =
    "td" ++ String.fromInt seq


