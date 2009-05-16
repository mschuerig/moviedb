dojo.provide('moviedb.Dispatcher');

dojo.declare('moviedb.Dispatcher', null, {
  constructor: function(node) {
    for (var i = 1, l = arguments.length; i < l; i++) {
      var spec = arguments[i];
      dojo.connect(node, 'on' + spec.event, this._makePublisher(node, spec.path, spec.topic));
    }
  },

  _makePublisher: function(root, path, topic) {
    return function(event) {
      var link = dojo.ancestor(event.target, path, root);
      if (link && link.pathname) {
        dojo.stopEvent(event);
        dojo.publish(topic, [link.pathname + link.search]);
      }
    }
  }
});
