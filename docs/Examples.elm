module Examples exposing (..)


type alias Model =
    { name : String
    , age : Int
    , ctor : Int
    }


type Animal
    = Cat
    | Dog


type LotsOfAnimals
    = Bat
    | Rabbit
    | Hat String


type Person
    = Person String Int


type LotsOfthings
    = LotsOfthings Int Int Int Int Int Int Int Int Int Int Int Int Int


simplePatternMatch : Animal -> ()
simplePatternMatch animal =
    case animal of
        Cat ->
            ()

        Dog ->
            ()


complexPatternMatch : LotsOfAnimals -> ()
complexPatternMatch animal =
    case animal of
        Bat ->
            ()

        Rabbit ->
            ()

        Hat x ->
            let
                _ =
                    Debug.log "x" x
            in
                ()


simpleFunction : Int -> Int -> Int
simpleFunction a b =
    a + b
