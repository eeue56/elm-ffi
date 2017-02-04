module FFI exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode exposing (Value)
import Native.FFI


{-| Given a function body and a list of arguments, return a value

-}
sync : String -> List Value -> Value
sync text args =
    Native.FFI.sync text (Encode.list args)


{-| Raise any value to Json. Useful for debugging
-}
asIs : a -> Value
asIs thing =
    Native.FFI.asIs thing
