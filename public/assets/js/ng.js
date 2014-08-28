angular.module('App', [])

.controller('MainController', ['$scope', '$http', function($scope, $http) {
  $http({method: 'GET', url: '/api/recent'}).
  success(function(data, status, headers, config) {
    $scope.contents = data;
  }).
  error(function(data, status, headers, config) {
  });
}])
.filter('range', [function() {
  return function(input, total) {
    total = parseInt(total);
    for (var i=0; i<total; i++)
      input.push(i);
    return input;
  };
}]);