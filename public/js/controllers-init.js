'use strict';

/* Init Controllers */

angular.module('vimEat.controllers', [])
.run(function($rootScope) {
    $rootScope.unRead = 0;
    $rootScope.isFocus = true;
    $rootScope.socket = null;
});
