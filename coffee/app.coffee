app = angular.module "codelab2", []

app.directive "codemirror", ->
    scope:
        ngModel: "="
    link: (scope, element, attrs) ->
        defaultOpts =
            "codemirror":
                lineNumbers: true
            "console":
                readOnly: true
        editor = CodeMirror.fromTextArea element[0], defaultOpts[attrs.codemirror]
        editor.on "change", ->
            scope.ngModel = editor.getValue()
            if not scope.$$phase then scope.$apply()
        if attrs.codemirror == "console"
            scope.$watch "ngModel", (value) -> 
                editor.setValue value
                editor.setCursor editor.lineCount()

        window[attrs.editor] = editor

app.controller "mainController", ($scope) ->
    $scope.editorOptions =
        lineNumbers: true
        win: "editorWin"
    $scope.cisei = "ci sono"
