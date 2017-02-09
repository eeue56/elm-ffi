# elm-ffi
A FFI interface for Elm

:bangbang: This library is intended for _experienced_ Elm developers only! If you haven't written a lot of Elm and end up here, try asking about your problem on Slack instead! :bangbang:

Both `sync` and `async` functions can introduce runtime errors in Elm and break everything. `safeAsync` and `safeSync` can be used more safely, as they wrap each call in `try..catch` and return a result. Note, if `safeAsync`'s code fails during callback evaluation, it will not be returned as a result and will cause runtime errors.


## Installation 

As this code contains native code, I suggest using [elm-github-install](https://github.com/gdotdesign/elm-github-install) to use this package. You'll also need to add `"native-modules": true` to your `elm-package.json`.


## Sync

Imagine you want to define your own logging function, but don't want the wrapper from `Debug.log`. 

With this library, you can do the following:

```elm

import FFI

log : a -> ()
log thing =
    FFI.sync "console.log(_0);" [ FFI.asIs thing ]
        |> (\_ -> ())

```

which can then be used like this:

```elm

someFunction =
    let 
        _ = log "Some thing is being called!"
    in 
        5

```

Each argument is applied in order of the list of arguments given - so `_0` is the first argument, then `_1` is the second and so on. 

In order to ensure that the code works okay, ensure that any function you make takes _each argument seperately_. Otherwise, the functions no longer work properly with partial application.


Note that `safeSync` exists in order to allow for safer creation of runtime functions, by instead returning a `Result`. For example:

```elm
safeLog : a -> ()
safeLog thing = 
    case FFI.safeSync "console.log(_0);" [ FFI.asIs thing ] of 
        Err message ->
            let
                _ = Debug.log "FFI log function did not work!" 
            in 
                ()
        Ok v ->
            ()
```


## Async

Imagine you want to return a value after a certain amount of time. You'd write

```elm
import FFI

returnAfterX : Int -> Value -> Task String Value
returnAfterX time value =
    FFI.async """
setTimeout(function(){
    callback(_succeed(_1))
}, _0)
"""
    [ Json.Encode.int time, value ]

```

Now you can use this as you would any other task. `_fail` can be used to produce the error task, while `_succeed` is for success cases. You have to wrap this value in a call to `callback` - which is used to tell the schedular that the task has completed.

