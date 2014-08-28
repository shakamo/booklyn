angular.module('App', [])
.controller('MainController', ['$scope', function ($scope) {}])
.run(['$http', function($http){
}])
.controller('CtrlCenter', ['$scope', '$http', function($scope, $http) {
  $http({method: 'GET', url: '/api/recent'}).
  success(function(data, status, headers, config) {
    // this callback will be called asynchronously
    // when the response is available
    $scope.contents = data;
  }).
  error(function(data, status, headers, config) {
    // called asynchronously if an error occurs
    // or server returns response with an error status.
  });
}])
.filter('range', function() {
  return function(input, total) {
    total = parseInt(total);
    for (var i=0; i<total; i++)
      input.push(i);
    return input;
  };
});