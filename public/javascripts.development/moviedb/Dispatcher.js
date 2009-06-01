dojo.provide('moviedb.Dispatcher');
dojo.require('dojo.NodeList-traverse');

dojo.declare('moviedb.Dispatcher', null, {
  constructor: function(node) {
    for (var i = 1, l = arguments.length; i < l; i++) {
      var spec = arguments[i];
      dojo.connect(node, 'on' + spec.event, this._makePublisher(spec.path, spec.topic));
    }
  },

  _makePublisher: function(path, topic) {
    return function(event) {
//      var link = dojo.ancestor(event.target, path, root);
      new dojo.NodeList(event.target).closest(path).forEach(function(link) {
        if (link.pathname) {
          dojo.stopEvent(event);
          dojo.publish(topic, [link.pathname + link.search]);
        }
      });
    }
  }
});
