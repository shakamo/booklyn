angular.module('App', [ 'ngRoute', 'ngAnimate' ])

.run(
    [
        '$rootScope',
        '$http',
        function($rootScope, $http) {

          $rootScope.weeks = [ [ '土曜日', 'Sat' ], [ '日曜日', 'Sun' ], [ '月曜日', 'Mon' ],
              [ '火曜日', 'Tue' ], [ '水曜日', 'Wed' ], [ '木曜日', 'Thu' ], [ '金曜日', 'Fri' ] ];
          $rootScope.atoz = [ 'あ', 'か', 'さ', 'た', 'な', 'は', 'ま', 'や', 'ら', 'わ' ];
        } ]).config(function($routeProvider, $locationProvider) {
  $routeProvider.when('/', {
    templateUrl : 'main.html',
    controller : 'ContentController'
  }).when('/week/:week', {
    templateUrl : 'main.html',
    controller : 'WeekController'
  }).when('/atoz/:atoz', {
    templateUrl : 'main.html',
    controller : 'AtozController'
  }).when('/episode/:id', {
    templateUrl : 'episode.html',
    controller : 'EpisodeController',
    resolve : {}
  }).when('/howto', {
    templateUrl : 'howto.html',
    controller : 'HowtoController',
    resolve : {}
  }).otherwise({
    redirectTo : '/'
  });

  // configure html5 to get links working on jsfiddle
  $locationProvider.html5Mode(true);
}).controller('MainController',
    [ '$rootScope', '$scope', '$http', function($rootScope, $scope, $http) {

    } ]).controller('ContentController',
    [ '$rootScope', '$scope', '$http', function($rootScope, $scope, $http, $routeParams) {
      $http({
        method : 'GET',
        url : '/api/recent'
      }).success(function(data, status, headers, config) {

        data.forEach(function(item) {
          var newDate = new Date();
          var date = item.created_at;
          newDate.setUTCFullYear(date.slice(0, 4));
          newDate.setUTCMonth(+date.slice(4, 6) - 1);
          newDate.setUTCDate(date.slice(6, 8));
          newDate.setUTCHours(date.slice(8, 10));
          newDate.setUTCMinutes(date.slice(10, 12));
          newDate.setUTCSeconds('0');
          item.date = newDate.toLocaleString("ja-JP");
        });

        $rootScope.contents = data;
        $rootScope.isHowto = false;
      }).error(function(data, status, headers, config) {
      });
      $rootScope.isHowto = false;
    } ]).controller(
    'WeekController',
    [ '$rootScope', '$scope', '$http', '$routeParams',
        function($rootScope, $scope, $http, $routeParams) {
          $scope.params = $routeParams;
          $http({
            method : 'GET',
            url : '/api/week/' + $scope.params.week
          }).success(function(data, status, headers, config) {

            data.forEach(function(item) {
              var newDate = new Date();
              var date = item.created_at;
              newDate.setUTCFullYear(date.slice(0, 4));
              newDate.setUTCMonth(+date.slice(4, 6) - 1);
              newDate.setUTCDate(date.slice(6, 8));
              newDate.setUTCHours(date.slice(8, 10));
              newDate.setUTCMinutes(date.slice(10, 12));
              newDate.setUTCSeconds('0');
              item.date = newDate.toLocaleString("ja-JP");
            });

            $rootScope.contents = data;
          }).error(function(data, status, headers, config) {
          });
          $rootScope.isHowto = false;
        } ]).controller(
    'AtozController',
    [ '$rootScope', '$scope', '$http', '$routeParams',
        function($rootScope, $scope, $http, $routeParams) {
          $scope.params = $routeParams;
          $http({
            method : 'GET',
            url : '/api/atoz/' + $scope.params.atoz
          }).success(function(data, status, headers, config) {

            data.forEach(function(item) {
              var newDate = new Date();
              var date = item.created_at;
              newDate.setUTCFullYear(date.slice(0, 4));
              newDate.setUTCMonth(+date.slice(4, 6) - 1);
              newDate.setUTCDate(date.slice(6, 8));
              newDate.setUTCHours(date.slice(8, 10));
              newDate.setUTCMinutes(date.slice(10, 12));
              newDate.setUTCSeconds('0');
              item.date = newDate.toLocaleString("ja-JP");
            });

            $rootScope.contents = data;
          }).error(function(data, status, headers, config) {
          });
          $rootScope.isHowto = false;
        } ]).controller('HowtoController',
    [ '$scope', '$rootScope', function($scope, $rootScope, $routeParams) {

      $rootScope.isHowto = true;
    } ]).controller(
    'EpisodeController',
    [ '$scope', '$http', '$routeParams', '$location', '$anchorScroll',
        function($scope, $http, $routeParams, $location, $anchorScroll) {
          $scope.params = $routeParams;
          $http({
            method : 'GET',
            url : '/api/episode/' + $scope.params.id
          }).success(function(data, status, headers, config) {

            data.episodes.forEach(function(item) {
              var newDate = new Date();
              var date = item.created_at;
              newDate.setUTCFullYear(date.slice(0, 4));
              newDate.setUTCMonth(+date.slice(4, 6) - 1);
              newDate.setUTCDate(date.slice(6, 8));
              newDate.setUTCHours(date.slice(8, 10));
              newDate.setUTCMinutes(date.slice(10, 12));
              newDate.setUTCSeconds('0');
              item.date = newDate.toLocaleString("ja-JP");
            });

            $scope.content = data;
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