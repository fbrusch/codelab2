app = angular.module "codelab2", []


app.directive "codemirror", ->
    link: (scope, element, attrs) ->
        defaultOpts = 
            lineNumbers: true
        window[attrs.editor] = CodeMirror.fromTextArea element[0], defaultOpts

app.controller "mainController", ($scope) ->
    $scope.editorOptions =
        lineNumbers: true
        win: "editorWin"
    $scope.cisei = "ci sono"
