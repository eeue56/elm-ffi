var _eeue56$elm_ffi$Native_FFI = function(){

    // given "console.log(_0);", return "function(_0) { console.log(_0); }("hello")"
    var sync = function(text, args) {
        var i = 0;

        var params = args.map(function(_){
            i++;
            return "_" + (i - 1).toString();
        }).join(', ');

        var functionString = "(function(" + params + ") {";
        var body = text + " })";
        var func = eval(functionString + body);
        var result = func.apply(null, args);

        if (typeof result === "undefined"){
            return null;
        }
        return result;
    };

    // expose your functions here
    return {
        sync: F2(sync),
        asIs: function(v) { return v; }
    };
}();