module FFI exposing (..)

{-|

@docs sync, safeSync
@docs async, safeAsync
@docs asIs, intoElm
-}

import Json.Decode as Decode
import Json.Encode as Encode exposing (Value)
import Task exposing (Task)
import Native.FFI


{-| Given a function body and a list of arguments, return a value

-}
sync : String -> List Value -> Value
sync text args =
    Native.FFI.sync text (Encode.list args)


{-| Same as sync, but if an error is encountered during running the function, it is
    returned as a result
-}
safeSync : String -> List Value -> Result String Value
safeSync text args =
    Native.FFI.makeSafe text (Encode.list args) False


{-| Raise any value to Json. Useful for debugging
-}
asIs : a -> Value
asIs thing =
    Native.FFI.asIs thing


{-| Extremely dangerous, only use for prototyping
-}
intoElm : Value -> a
intoElm thing =
    Native.FFI.intoElm thing


{-| Like sync but works with async stuff. Use `callback(_succeed(value))` or `callback(_fail(value))`
-}
async : String -> List Value -> Task Value Value
async text args =
    Native.FFI.async text (Encode.list args)


{-| Same as `async`, but returns a result
-}
safeAsync : String -> List Value -> Result String (Task Value Value)
safeAsync text args =
    Native.FFI.makeSafe text (Encode.list args) True
