var _eeue56$elm_ffi$Native_FFI = function(){

    // given "console.log(_0);", return "function(_0) { console.log(_0); }("hello")"
    var makeFunction = function(text, args, isAsync){
        var i = 0;

        var params = args.map(function(_){
            i++;
            return "_" + (i - 1).toString();
        });

        if (isAsync) {
            params.push("_succeed");
            params.push("_fail");
        }

        var joinedParams = params.join(', ');

        var functionString = "(function(" + joinedParams + ") {";
        var body = text + "\n});";
        return functionString + body;
    };

    var schedulerWrapper = function(functionBody){
        var head = "return _elm_lang$core$Native_Scheduler.nativeBinding(function (callback){ ";

        var tail = "});";

        return head + functionBody + tail;
    };

    var sync = function(text, args) {
        var func = eval(makeFunction(text, args, false));
        var result = func.apply(null, args);

        if (typeof result === "undefined"){
            return null;
        }
        return result;
    };

    var async = function(text, args) {
        // wrap the code
        var wrapped = schedulerWrapper(text);
        // make a function based on the original args with async mode enabled
        var funcBody = makeFunction(wrapped, args, true);
        var func = eval(funcBody);

        // create a copy and add succeed/fail
        var argsCopy = args.slice();
        argsCopy.push(_elm_lang$core$Native_Scheduler.succeed);
        argsCopy.push(_elm_lang$core$Native_Scheduler.fail);

        var result = func.apply(null, argsCopy);

        if (typeof result === "undefined"){
            return null;
        }
        return result;
    };

    var makeSafe = function(text, args, isAsync) {
        var func = sync;
        if (isAsync) {
            func = async;
        }

        try {
            var result = func(text, args);
            return {
                ctor: "Ok",
                _0: result
            };
        } catch (e) {
            return {
                ctor: 'Err',
                _0: 'Error during load: ' + e.message
            };
        }
    
    };

    var intoElm = function(a){
        return a;
    };

    // expose your functions here
    return {
        sync: F2(sync),
        async: F2(async),
        asIs: function(v) { return v; },
        intoElm: intoElm,
        makeSafe: F3(makeSafe)
    };
}();