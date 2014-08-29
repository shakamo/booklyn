angular.module('App', [])

.controller('MainController', ['$scope', '$http', function($scope, $http) {
  $http({method: 'GET', url: '/api/recent'}).
  success(function(data, status, headers, config) {
    $scope.contents = data;
  }).
  error(function(data, status, headers, config) {
  });
}])
.controller('RightController', ['$scope', '$http', function($scope, $http) {
  $http({method: 'GET', url: '/api/history'}).
  success(function(data, status, headers, config) {
    $scope.histories = data;
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
}])
.filter('utc_to_local', [function() {
  return function(date, format) {
    var newDate = new Date();
    newDate.setUTCFullYear(date.slice(0,4));
    newDate.setUTCMonth(+date.slice(4,6) - 1);
    newDate.setUTCDate(date.slice(6,8));
    newDate.setUTCHours(date.slice(8,10));
    newDate.setUTCMinutes(date.slice(10,12));
    newDate.setUTCSeconds('0');
    return newDate.toLocaleString("ja-JP");
  };
}])
.filter('groupBy', function($parse) {
    return _.memoize(function(items, field) {
        var getter = $parse(field);
        return _.groupBy(items, function(item) {
            return getter(item);
        });
    });
});