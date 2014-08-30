angular.module('App', [ 'ngRoute', 'ngAnimate' ])

.run([ '$rootScope', '$http', function($rootScope, $http) {
  $http({
    method : 'GET',
    url : '/api/recent'
  }).success(function(data, status, headers, config) {
    $rootScope.contents = data;
  }).error(function(data, status, headers, config) {
  });
  $rootScope.weeks = ['土曜日','日曜日','月曜日','火曜日','水曜日','木曜日','金曜日'];
  $rootScope.atoz = ['あ','か','さ','た','な','は','ま','や','ら','わ'];
} ]).config(function($routeProvider, $locationProvider) {
  $routeProvider.when('/', {
    templateUrl : 'main.html',
    controller : 'ContentController'
  }).when('/episode/:id', {
    templateUrl : 'episode.html',
    controller : 'EpisodeController',
    resolve : {
    }
  }).when('/howto', {
    templateUrl : 'howto.html',
    controller : 'HowtoController',
    resolve : {
    }
  }).when('/Book/:bookId/ch/:chapterId', {
    templateUrl : 'chapter.html',
    controller : 'ChapterController'
  });

  // configure html5 to get links working on jsfiddle
  $locationProvider.html5Mode(true);
}).controller('MainController', [ '$rootScope', '$scope', '$http', function($rootScope, $scope, $http) {

  $rootScope.isHowto = false;
} ]).controller('ContentController', [ '$scope', '$http', function($scope, $http, $routeParams) {

} ]).controller('HowtoController', [ '$scope', '$rootScope', function($scope, $rootScope, $routeParams) {

  $rootScope.isHowto = true;
} ]).controller('EpisodeController', [ '$scope', '$http', '$routeParams', function($scope, $http, $routeParams) {
  $scope.params = $routeParams;
  $http({
    method : 'GET',
    url : '/api/episode/' + $scope.params.id
  }).success(function(data, status, headers, config) {
    $scope.episode = data;
  }).error(function(data, status, headers, config) {

  });
} ]).controller('RightController', [ '$scope', '$http', function($scope, $http) {
  $http({
    method : 'GET',
    url : '/api/history'
  }).success(function(data, status, headers, config) {
    $scope.histories = data;
  }).error(function(data, status, headers, config) {

  });
} ]).filter('range', function() {
  return function(input, total) {
    total = parseInt(total);
    for (var i = 0; i < total; i++)
      input.push(i);
    return input;
  };
}).filter('utc_to_local', function() {
  return function(date, format) {
    var newDate = new Date();
    newDate.setUTCFullYear(date.slice(0, 4));
    newDate.setUTCMonth(+date.slice(4, 6) - 1);
    newDate.setUTCDate(date.slice(6, 8));
    newDate.setUTCHours(date.slice(8, 10));
    newDate.setUTCMinutes(date.slice(10, 12));
    newDate.setUTCSeconds('0');
    return newDate.toLocaleString("ja-JP");

  };
}).filter('groupBy', function($parse) {
  return _.memoize(function(items, field) {
    var getter = $parse(field);
    return _.groupBy(items, function(item) {
      return getter(item);
    });
  });
});