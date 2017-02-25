# Elm compiled documentation


This documentation is intended to help answer questions on how Elm works entirely. It will aim to be always true to the current release of Elm - which is currently 0.18.

## Types

No type information is preserved after compiling Elm. However, these are some things that are preserved. These are mainly constructors. 


### Type aliases

Type aliases are represented as pure JS objects at runtime. Unlike union types, they do not have the field `ctor`. 

```elm
type alias Model = {
	name : String, 
	age : Int
}
```

gets compiled into 

```js
var _user$project$Examples$Model = F2(function(name, age){
	return { name: name, age: age};
});
```


### Union types

Union types share no relation at runtime in Elm. Each constructor is represented by an object with a `ctor` field. The `ctor` field is the name of the constructor. For each argument given, a field named `_{n}` is added to the object, where `n` is the position of the argument, starting at 0. Constructors with more than 1 argument are functions wrapped in `F2..9`.

#### Without args

```elm
type Animal = Dog | Cat
```

gets compiled into

```js
var _user$project$Examples$Dog = {ctor: 'Dog'};
var _user$project$Examples$Cat = {ctor: 'Cat'};
```

#### With args

```elm
type Person
    = Person String Int
```

gets compiled into

```js
var _user$project$Examples$Person = F2(
	function (a, b) {
		return {ctor: 'Person', _0: a, _1: b};
	});
```


#### Pattern matching

Pattern matching on union types is done via switch statements when there is more than 2 branches. For 2 branches, a simple if statement is used. The last pattern in a pattern match is always converted to a default block.

```elm
simplePatternMatch : Animal -> ()
simplePatternMatch animal =
    case animal of
        Cat ->
            ()

        Dog ->
            ()
```

gets compiled into

```js
var _user$project$Examples$simplePatternMatch = function (animal) {
	var _p1 = animal;
	if (_p1.ctor === 'Cat') {
		return {ctor: '_Tuple0'};
	} else {
		return {ctor: '_Tuple0'};
	}
};
```

Notice the switch statement used instead here.

```elm
complexPatternMatch : LotsOfAnimals -> ()
complexPatternMatch animal =
    case animal of
        Bat ->
            ()

        Rabbit ->
            ()

        Hat ->
            ()
```

gets compiled into

```
var _user$project$Examples$complexPatternMatch = function (animal) {
	var _p0 = animal;
	switch (_p0.ctor) {
		case 'Bat':
			return {ctor: '_Tuple0'};
		case 'Rabbit':
			return {ctor: '_Tuple0'};
		default:
			return {ctor: '_Tuple0'};
	}
};
```



## Functions

Functions with more than one argument are wrapped using the `F2..9` functions. These allow for partial application to function objects using `A2..9`. Functions with more than 9 arguments are expanded fully out. For this reason, if you wish have minimally produced Elm files, it is recommended to keep arguments less than 9.


```elm
simpleFunction : Int -> Int -> Int
simpleFunction a b = 
    a + b
```

gets compiled into

```js
var _user$project$Examples$simpleFunction = F2(
	function (a, b) {
		return a + b;
	});
```

A constructor is represented as a function. Therefore, the Elm code below 

```elm
type LotsOfthings
    = LotsOfthings Int Int Int Int Int Int Int Int Int Int Int Int Int
```

gets compiled into

```js
var _user$project$Examples$LotsOfthings = function (a) {
	return function (b) {
		return function (c) {
			return function (d) {
				return function (e) {
					return function (f) {
						return function (g) {
							return function (h) {
								return function (i) {
									return function (j) {
										return function (k) {
											return function (l) {
												return function (m) {
													return {ctor: 'LotsOfthings', _0: a, _1: b, _2: c, _3: d, _4: e, _5: f, _6: g, _7: h, _8: i, _9: j, _10: k, _11: l, _12: m};
												};
											};
										};
									};
								};
							};
						};
					};
				};
			};
		};
	};
};
```

## Native Modules