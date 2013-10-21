// Generated by CoffeeScript 1.6.3
(function() {
  var LightBox, LocationQuiz, Map, Menu, QuizBox;

  window.App = (function() {
    var CORRECT_REGION_COLOR, INCORRECT_REGION_COLOR, MAP_CONTAINER_ID;

    MAP_CONTAINER_ID = 'map-container';

    CORRECT_REGION_COLOR = '#2ECC71';

    INCORRECT_REGION_COLOR = '#E74C3C';

    function App() {
      QuizBox.init();
      QuizBox.hide();
      this.menu = new Menu({
        onSelectMap: $.proxy(this._renderMap, this),
        onStartQuiz: $.proxy(this._startQuiz, this)
      });
      this._renderMap(this.menu.getSelectedMap());
    }

    App.prototype._renderMap = function(mapName) {
      this.map = new Map(MAP_CONTAINER_ID, mapName);
      return this.map.render();
    };

    App.prototype._startQuiz = function() {
      this.menu.hide();
      this.menu.hideScore();
      this.map.clearSelectedRegions();
      this._startLocationQuiz();
      return QuizBox.show();
    };

    App.prototype._startLocationQuiz = function() {
      var quiz,
        _this = this;
      quiz = new LocationQuiz(this.map.getRegions());
      QuizBox.askQuestion(quiz.getQuestion());
      QuizBox.onSkipQuestion = function() {
        return QuizBox.askQuestion(quiz.getQuestion());
      };
      return this.map.bindEvents({
        regionLabelShow: function(e, label, code) {
          return _this.map.isRegionSelected(code);
        },
        regionClick: function(e, regionCode) {
          var askedRegion, clickedRegion, nextQuestion, status;
          clickedRegion = _this.map.regionForCode(regionCode);
          askedRegion = quiz.currentRegion;
          if (quiz.answerQuestion(clickedRegion)) {
            _this.map.selectRegion(regionCode, CORRECT_REGION_COLOR);
          } else {
            _this.map.selectRegion(_this.map.codeForRegion(askedRegion), INCORRECT_REGION_COLOR);
          }
          nextQuestion = quiz.getQuestion();
          if (nextQuestion != null) {
            return QuizBox.askQuestion(nextQuestion);
          } else {
            status = quiz.status();
            return _this._endQuiz(status.numCorrect, status.questionCount);
          }
        }
      });
    };

    App.prototype._endQuiz = function(numCorrect, questionCount) {
      QuizBox.hide();
      this.menu.show();
      return this.menu.showScore(numCorrect);
    };

    return App;

  })();

  LightBox = (function() {
    var backdrop;

    backdrop = $('<div class="light-box-bg"></div>');

    LightBox.showBackdrop = (function() {
      var added;
      added = false;
      return function() {
        if (added) {
          return backdrop.show();
        } else {
          $(document.body).append(backdrop);
          return added = true;
        }
      };
    })();

    LightBox.hideBackdrop = function() {
      return backdrop.hide();
    };

    function LightBox(containerID) {
      this.el = $('#' + containerID);
      this._centerInWindow();
      this.show();
      this._bindEvents();
    }

    LightBox.prototype.hide = function() {
      LightBox.hideBackdrop();
      return this.el.hide();
    };

    LightBox.prototype.show = function() {
      LightBox.showBackdrop();
      return this.el.show();
    };

    LightBox.prototype._bindEvents = function() {
      var _this = this;
      return $(window).resize(function() {
        return _this._centerInWindow();
      });
    };

    LightBox.prototype._centerInWindow = function() {
      var $window, verticalOffset;
      $window = $(window);
      verticalOffset = 50;
      return this.el.css({
        left: ($window.width() - this.el.width()) / 2,
        top: (($window.height() - this.el.height()) / 2) - verticalOffset
      });
    };

    return LightBox;

  })();

  LocationQuiz = (function() {
    function LocationQuiz(regions) {
      this.regions = regions;
      this.regionsCount = regions.length;
      this.currentRegion = null;
      this.numCorrect = 0;
    }

    LocationQuiz.prototype.getQuestion = function() {
      var randomIndex;
      if (this.regions.length === 0) {
        return null;
      } else {
        randomIndex = Math.floor(Math.random() * this.regions.length);
        this.currentRegion = this.regions[randomIndex];
        return "Where is " + this.currentRegion + "?";
      }
    };

    LocationQuiz.prototype.answerQuestion = function(answer) {
      var correct, index;
      index = $.inArray(this.currentRegion, this.regions);
      this.regions.splice(index, 1);
      correct = answer === this.currentRegion;
      if (correct) {
        this.numCorrect += 1;
      }
      this.currentRegion = null;
      return correct;
    };

    LocationQuiz.prototype.status = function() {
      return {
        questionsLeft: this.regions.length,
        questionCount: this.regionsCount,
        numCorrect: this.numCorrect
      };
    };

    return LocationQuiz;

  })();

  Map = (function() {
    var BACKGROUND_COLOR;

    BACKGROUND_COLOR = '#2980B9';

    Map.loadMap = (function() {
      var loaded;
      loaded = {};
      return function(mapName, callback) {
        if (loaded[mapName]) {
          return callback();
        } else {
          return $.get("vendor/jvectormap/maps/" + mapName + ".js", function(loadScript) {
            eval(loadScript);
            loaded[mapName] = true;
            return callback();
          });
        }
      };
    })();

    function Map(containerID, mapName) {
      this.el = $('#' + containerID);
      this.mapName = mapName;
    }

    Map.prototype.render = function() {
      var _this = this;
      return Map.loadMap(this.mapName, function() {
        return _this._createMap();
      });
    };

    Map.prototype.clearSelectedRegions = function() {
      return this.map.clearSelectedRegions();
    };

    Map.prototype.isRegionSelected = function(regionCode) {
      var selected;
      selected = this.map.getSelectedRegions();
      return $.inArray(regionCode, selected) !== -1;
    };

    Map.prototype.selectRegion = function(regionCode, color) {
      this.map.regions[regionCode].element.style.selected.fill = color;
      return this.map.setSelectedRegions(regionCode);
    };

    Map.prototype.codeForRegion = function(regionName) {
      var data, regionCode, _ref;
      _ref = this.map.regions;
      for (regionCode in _ref) {
        data = _ref[regionCode];
        if (data.config.name === regionName) {
          return regionCode;
        }
      }
    };

    Map.prototype.regionForCode = function(regionCode) {
      return this.map.getRegionName(regionCode);
    };

    Map.prototype.getRegions = function() {
      var data, regionCode, _ref, _results;
      _ref = this.map.regions;
      _results = [];
      for (regionCode in _ref) {
        data = _ref[regionCode];
        _results.push(data.config.name);
      }
      return _results;
    };

    Map.prototype.bindEvents = function(events) {
      var callback, event, _results;
      this.el.unbind();
      _results = [];
      for (event in events) {
        callback = events[event];
        _results.push(this.el.bind("" + event + ".jvectormap", callback));
      }
      return _results;
    };

    Map.prototype._createMap = function() {
      this.el.empty();
      this.el.vectorMap({
        map: this.mapName,
        backgroundColor: BACKGROUND_COLOR
      });
      return this.map = this.el.vectorMap('get', 'mapObject');
    };

    return Map;

  })();

  Menu = (function() {
    function Menu(opts) {
      this.onSelectMap = opts.onSelectMap;
      this.onStartQuiz = opts.onStartQuiz;
      this._createMenu();
      this.hideScore();
      this._bindEvents();
    }

    Menu.prototype.show = function() {
      return this.lightbox.show();
    };

    Menu.prototype.hide = function() {
      return this.lightbox.hide();
    };

    Menu.prototype.getSelectedMap = function() {
      return $('#map-type .pure-button-active').first().data('map');
    };

    Menu.prototype.showScore = function(numCorrect) {
      return $('#score').show().children('span').text(numCorrect);
    };

    Menu.prototype.hideScore = function(numCorrect) {
      return $('#score').hide();
    };

    Menu.prototype._createMenu = function() {
      return this.lightbox = new LightBox('menu');
    };

    Menu.prototype._bindEvents = function() {
      var _this = this;
      $('#start-quiz').click($.proxy(this.onStartQuiz, this));
      return $('#map-type .pure-button').click((function() {
        var $active;
        $active = $('#map-type .pure-button-active');
        return function(e) {
          $active.removeClass('pure-button-active');
          $active = $(e.target).addClass('pure-button-active');
          return _this.onSelectMap(_this.getSelectedMap());
        };
      })());
    };

    return Menu;

  })();

  QuizBox = (function() {
    var $el;
    $el = $('#quiz-box');
    return {
      init: function() {
        return $el.children('.skip-question').click(function() {
          return QuizBox.onSkipQuestion();
        });
      },
      askQuestion: function(question) {
        return $el.children('h3').text(question);
      },
      show: function() {
        return $el.show();
      },
      hide: function() {
        return $el.hide();
      },
      onSkipQuestion: function() {
        throw new Error('Must be overwritten!');
      }
    };
  })();

}).call(this);
