module Main exposing (..)

import Html
import Html.Events
import Json.Encode exposing (Value)
import Task exposing (Task)
import FFI


log : a -> ()
log thing =
    FFI.sync "console.log(_0);" [ FFI.asIs thing ]
        |> (\_ -> ())


logWithMessage : String -> a -> ()
logWithMessage message thing =
    FFI.sync "console.log(_0, _1);" [ Json.Encode.string message, FFI.asIs thing ]
        |> (\_ -> ())


returnAfter1000 : Value -> Task Value Value
returnAfter1000 value =
    FFI.async """
setTimeout(function(){
    callback( _succeed(_0) );
}, 1000);
"""
        [ value ]


type Msg
    = Thing (Result Value Value)
    | Trigger


update : Msg -> () -> ( (), Cmd Msg )
update msg _ =
    let
        _ =
            log msg
    in
        case msg of
            Trigger ->
                ( ()
                , Task.attempt Thing
                    (returnAfter1000 <| Json.Encode.int 50)
                )

            Thing thing ->
                let
                    _ =
                        log ("We got " ++ toString thing)
                in
                    ( (), Cmd.none )


logExample =
    let
        _ =
            logWithMessage "An example of saying hello:" "hello"

        _ =
            log { something = 1, elseHere = 2 }
    in
        Html.text ""


main =
    Html.program
        { init = ( (), Cmd.none )
        , view = (\_ -> Html.div [ Html.Events.onClick Trigger ] [ Html.text "Click to see 50" ])
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
