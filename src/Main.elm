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

port module Main exposing (main)

import Browser
import Html exposing (Html, Attribute, div, input, text, button, h1, select, option)
import Html.Attributes exposing (id, value, placeholder, class, size, autofocus, disabled)
import Html.Events exposing (onClick, onInput)

-- MAIN

-- {* Signature of the Browser.element *}
-- element :
--    { init : flags -> ( model, Cmd msg )
--    , update : msg -> model -> ( model, Cmd msg )
--    , subscriptions : model -> Subs msg
--    , view : model -> Html msg
--    }
--    -> Program flags model msg

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


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


port cache : Content -> Cmd msg

-- INIT

init : Content  -> (Model, Cmd Msg)
init newContent =
    (initialModel newContent
    , Cmd.none
    )


initialModel : Content -> Model
initialModel newContent =
    { content = newContent
    , selected = ""
    , staged = ""
    , seq = 100
    }


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none


---- UPDATE

type Msg
    = AddStaged
    | HoldSelected TodoKey
    | RemoveNewest
    | RemoveSelected
    | Reset
    | StageInput TodoText


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =

    case msg of

        AddStaged ->
            let
                newSeq = (+) 1 model.seq
                newKey = generateKey newSeq
                newToDo = {value = newKey, txt = model.staged}
                newContent = (::) newToDo model.content
            in
            ({model |  seq = newSeq, content = newContent, staged = "", selected = ""}
            , cache newContent
            )

        StageInput todoTxt ->
            ({model | staged = todoTxt}
            , Cmd.none
            )

        RemoveNewest ->
            let
                newContent = removeLatest model
            in ({model | content = newContent,  staged = "", selected = ""}
            , cache newContent
            )

        HoldSelected todoKey ->
            ({model | selected = todoKey}
            , Cmd.none
            )

        RemoveSelected ->
            let
                newContent = removeSelected model
            in ({model | content = newContent, staged = "", selected = ""}
            , cache newContent
            )

        Reset ->
            let
                newContent = []
            in
            (initialModel newContent, cache newContent)


generateKey : Seq -> TodoKey
generateKey seq =
    "td" ++ String.fromInt seq


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


removeSelected : Model -> Content
removeSelected  model =
    let
        filterFunc = \todo -> todo.value /= model.selected
    in
    List.filter filterFunc model.content


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
                    button [onClick AddStaged, class "btn btn-primary", disabled (String.isEmpty model.staged) ] [text "Add"]
                    , button [onClick RemoveSelected, class "btn btn-secondary", disabled (String.isEmpty model.selected)] [text "Remove Selection"]
                    , button [onClick RemoveNewest, class "btn btn-secondary", disabled (List.isEmpty model.content)] [text "Remove Top"]
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
                select [size 15, onInput HoldSelected] (renderContent model.content)
            ]
        ]

    ]

  ]

