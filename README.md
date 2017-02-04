# elm-ffi
An FFI interface for Elm


This inferface currently only supports sync functions.

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