# elm-ffi
An FFI interface for Elm

:bangbang: This library is intended for _experienced_ Elm developers only! If you haven't written a lot of Elm and end up here, try asking about your problem on Slack instead! :bangbang:


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


## Async

Imagine you want to return a value after a certain amount of time. You'd write

```elm
import FFI

returnAfterX : Int -> Value -> Task String Value
returnAfterX time value =
    FFI.async """
setTimeout(function(){
    _succeed(_1)
}, _0)
"""
    [ Json.Encode.int time, value ]

```

Now you can use this as you would any other task. `_fail` can be used to produce the error task, while `_succeed` is for success cases.
