# elm-todo
This is a simple self-contained TODO list implemented in Elm. It uses simple
demo persistance via html 5 localstorage `saveItem` and `loadItem` 

## Try
Carry out the following steps:
1. Ensure that Elm infrastructure is installed: [https://guide.elm-lang.org/install.html](https://guide.elm-lang.org/install.html)
1. Clone the repo from [https://github.com/mauget/elm-todo.git](https://github.com/mauget/elm-todo.git)
1. Compile Main.elm to elm.js using a command from the project root: `elm make src/Main.elm --output=elm.js`
1. Open [./index.html](./index.html) in a browser; no server needed for this application 

We added layout and style to the UI via index.html links to 
Bootstrap 4 CSS and local styles. A screenshot of the app follows. 

![Styled todo image](doc/Elm-todo-styled.png)

## Persistance
Local storage, as used here, is simplistic **demo** persistance. It caches the
**todo** list via an Elm flag and port, using JavaScript within the `index.html` 
`<script>` tag. The downside:

+ Each persisted todo collection exists uniquely in each given 
vendor browser-URL. 
+ Distinct tabs or windows of a given browser-url combination replace the single list at each UI event. 

Realistic multi-client data persistence could implemented via Elm http. 
See [An Introduction to Elm - HTTP](https://guide.elm-lang.org/effects/http.html).

## Development Environment 

Follow the guidelines at 
[Elm Language Intallation](https://guide.elm-lang.org/install.html)


## References

+ [An Introduction to Elm](https://guide.elm-lang.org/)
+ [Elm Syntax](https://elm-lang.org/docs/syntax#operators) 
