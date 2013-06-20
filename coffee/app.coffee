app = angular.module "codelab2", []

app.service "channel", ($rootScope) ->
    alert "channel service activated..."
    scope = $rootScope.$new()
    socket = new BCSocket '/channel'
    socket.onopen = -> 
        console.log "channel opened"
    socket.onmessage = (message) ->
        scope.$broadcast "message", message
    return {
        scope: -> scope
    }

app.directive "channelList", (channel) ->
    restrict: "E"
    template: "<ul></ul>"
    replace: yes
    scope: yes
    link: (scope, element, attrs) ->
        channelScope = channel.scope()
        channelScope.$on "message", (event, args)->
            element.append("<li>"+JSON.stringify(args)+"</li>")

app.directive "codeEditor", (appConsole) ->
    restrict: 'E'
    scope:
        ngModel: "="
    template: "<textarea></textarea>"
    replace: yes
    link: (scope, element, attrs) ->
        defaultOpts =
                lineNumbers: true
        editor = CodeMirror.fromTextArea element[0], defaultOpts
        editor.on "change", ->
            scope.ngModel = editor.getValue()
            if not scope.$$phase then scope.$apply()

app.directive "logConsole", (appConsole, $compile) ->
    scope: true
    restrict: 'E'
    template: "<textarea></textarea>"
    replace: true
    link: (scope, element, attrs) ->
        opts =
            readOnly: true
        editor = CodeMirror.fromTextArea element[0], opts
        logScope = appConsole.scope()
        logScope.$on "newMsg", ->
            editor.setValue appConsole.getLogText()
            editor.setCursor editor.lineCount()

app.service "funcGen", (appConsole)->
    generate: (str) ->
        return new Function("param",str)

app.directive "functionGenerate", (funcGen, appConsole) ->
    scope:
        f: '='
        source: "="
    link: (scope, element, attrs) ->
        scope.compile = ->
            alert "compiling..."
            scope.functionGenerate = funcGen.generate scope.x
            appConsole.log "Compiling function..."
    controller: ($scope) ->
        $scope.compile = -> alert "compiling in the directive!!"

app.service "appConsole", ($rootScope) ->
    logScope = $rootScope.$new()
    logText = ""
    return {
        scope: -> logScope
        log: (msg) ->
            logText += msg + "\n"
            logScope.$broadcast "newMsg"
        getLogText: -> logText
    }

app.directive "resultWidget", ($compile) ->
    restrict: "E"
    scope:
        f: "="
    template: """
    <table>
        <tr ng-repeat="i in result">
            <td>{{$index}}</td>
            <td>{{i}}</td>
        </tr>
    </table>"""
    link: (scope, element, attrs) ->
        scope.result = {}
        scope.$on attrs.render, -> 
            scope.result = (scope.f(x) for x in [1..10])

app.controller "mainController", ($scope, $rootScope, funcGen) ->

    $scope.generateFunction = ->
        $scope.f = funcGen.generate $scope.x
    $scope.x = ""
    $scope.compile = (x) ->
        funcGen.generate x


