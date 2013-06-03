app = angular.module "codelab2", []
app.directive "clWelcome", () ->
    restrict: 'E'
    template: "<p>Welcome!!</p>"

