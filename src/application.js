// Generated by CoffeeScript 1.6.2
(function() {
  var WorldMapView;

  WorldMapView = (function() {
    function WorldMapView(container_id) {
      this.el = $('#' + container_id);
      this.initEvents();
    }

    WorldMapView.prototype.initEvents = function() {
      var _this = this;

      return $(window).resize(function() {
        return _this.createMap();
      });
    };

    WorldMapView.prototype.createMap = function() {
      var $window, map;

      map = this.el.vectorMap({
        map: 'world_mill_en'
      });
      $window = $(window);
      return map.setSize($window.width(), $window.height());
    };

    return WorldMapView;

  })();

  $(document).ready(function() {
    var world;

    world = new WorldMapView('world-map');
    return world.createMap();
  });

}).call(this);
