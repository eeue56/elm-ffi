module Main exposing (..)

import Html
import Json.Encode
import FFI


log : a -> ()
log thing =
    FFI.sync "console.log(_0);" [ FFI.asIs thing ]
        |> (\_ -> ())


logWithMessage : String -> a -> ()
logWithMessage message thing =
    FFI.sync "console.log(_0, _1);" [ Json.Encode.string message, FFI.asIs thing ]
        |> (\_ -> ())


main =
    let
        _ =
            logWithMessage "An example of saying hello:" "hello"

        _ =
            log { something = 1, elseHere = 2 }
    in
        Html.text ""
