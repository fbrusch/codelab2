app = angular.module "codelab2", []


app.directive "codemirror", ->
    scope:
        ngModel: "="
    link: (scope, element, attrs) ->
        defaultOpts = 
            lineNumbers: true
        editor = CodeMirror.fromTextArea element[0], defaultOpts
        editor.on "change", ->
            scope.ngModel = editor.getValue()
            if not scope.$$phase then scope.$apply()
        window[attrs.editor] = editor

app.controller "mainController", ($scope) ->
    $scope.editorOptions =
        lineNumbers: true
        win: "editorWin"
    $scope.cisei = "ci sono"
