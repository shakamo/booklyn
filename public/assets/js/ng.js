angular.module('App', [ 'ngRoute', 'ngAnimate', 'snap' ]).run(
    [ '$rootScope', '$http', function($rootScope, $http) {

      $rootScope.weeks = [ {
        ja : '土曜日',
        en : 'Sat'
      }, {
        ja : '日曜日',
        en : 'Sun'
      }, {
        ja : '月曜日',
        en : 'Mon'
      }, {
        ja : '火曜日',
        en : 'Tue'
      }, {
        ja : '水曜日',
        en : 'Wed'
      }, {
        ja : '木曜日',
        en : 'Thu'
      }, {
        ja : '金曜日',
        en : 'Fri'
      } ];

      $rootScope.atoz = [ {
        ja : 'あ',
        en : 'a'
      }, {
        ja : 'か',
        en : 'k'
      }, {
        ja : 'さ',
        en : 's'
      }, {
        ja : 'た',
        en : 't'
      }, {
        ja : 'な',
        en : 'n'
      }, {
        ja : 'は',
        en : 'h'
      }, {
        ja : 'ま',
        en : 'm'
      }, {
        ja : 'や',
        en : 'y'
      }, {
        ja : 'ら',
        en : 'r'
      }, {
        ja : 'わ',
        en : 'w'
      } ];
    } ]).config(function($routeProvider, $locationProvider) {
  $routeProvider.when('/', {
    templateUrl : 'main.html',
    controller : 'ContentController'
  }).when('/collapse-atoz-anime', {
    templateUrl : 'main.html',
    controller : 'collapseController'
  }).when('/collapse-week-anime', {
    templateUrl : 'main.html',
    controller : 'collapseController'
  }).when('/atoz/:atoz', {
    templateUrl : 'main.html',
    controller : 'AtozController'
  }).when('/week/:week', {
    templateUrl : 'main.html',
    controller : 'WeekController'
  }).when('/episode/:id', {
    templateUrl : 'episode.html',
    controller : 'EpisodeController',
    resolve : {}
  }).when('/howto', {
    templateUrl : 'howto.html',
    controller : 'HowtoController',
    resolve : {}
  }).otherwise({
  });

  // configure html5 to get links working on jsfiddle
  $locationProvider.html5Mode(true);
}).controller('MainController',
    [ '$rootScope', '$scope', '$http', function($rootScope, $scope, $http) {
      $scope.snapOpts = {
          disable: 'right'
        };
    } ]).controller('ContentController',
        [ '$rootScope', '$scope', '$http', function($rootScope, $scope, $http, $routeParams) {
          $rootScope.contents = [];
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
        } ]).controller('collapseController',
            ['$location', '$anchorScroll', function($location, $anchorScroll) {
              // $location.hash('top');
              // $anchorScroll();
            } ]).controller(
    'WeekController',
    [ '$rootScope', '$scope', '$http', '$routeParams',
        function($rootScope, $scope, $http, $routeParams) {
          $rootScope.contents = [];
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
          $rootScope.contents = [];
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
          $scope.content = [];
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
(function(i, s, o, g, r, a, m) {
  i['GoogleAnalyticsObject'] = r;
  i[r] = i[r] || function() {
    (i[r].q = i[r].q || []).push(arguments)
  }, i[r].l = 1 * new Date();
  a = s.createElement(o), m = s.getElementsByTagName(o)[0];
  a.async = 1;
  a.src = g;
  m.parentNode.insertBefore(a, m)
})(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');

ga('create', 'UA-54425801-1', 'auto');
ga('send', 'pageview');