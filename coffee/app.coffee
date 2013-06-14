app = angular.module "codelab2", []

app.directive "codemirror", ->
    scope:
        ngModel: "="
    link: (scope, element, attrs) ->
        defaultOpts =
            "codemirror":
                lineNumbers: true
                value: "not console"
            "console":
                readOnly: true
                value: "console"
        editor = CodeMirror.fromTextArea element[0], defaultOpts[attrs.codemirror]
        if not (attrs.codemirror == "console")
            editor.on "change", ->
                scope.ngModel = editor.getValue()
                if not scope.$$phase then scope.$apply()

        if attrs.codemirror == "console"
            scope.$watch "ngModel", (value) -> 
                editor.setValue value
                editor.setCursor editor.lineCount()

        window[attrs.editor] = editor

app.service "funcGen", ->
    generate: (str) ->
        return new Function("param",str)


app.directive "resultWidget", ($compile) ->
    restrict: "E"
    scope:
        f: "="
    template: "<p> Value: {{result.value}}, Message: {{result.message}}</p>"
    link: (scope, element, attrs) ->
        scope.result = {}
        scope.$on attrs.render, -> 
            alert "rendering"
            scope.result.value = scope.f(10)
        #$compile(element)(scope)
        
app.controller "mainController", ($scope, funcGen) ->
    $scope.f = -> {value:45, message:"asd"}
    $scope.generateFunction = ->
        $scope.f = funcGen.generate $scope.x
        alert "function generated"
    $scope.emitops = ->
        alert "emitting ops"
        $scope.$broadcast "render"
    $scope.cisei = "ci sono"
    $scope.res =
        value: 10
        message: "fottiti"
    $scope.x = ""

