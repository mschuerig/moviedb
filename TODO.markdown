
General
-------

* image attachments
* revenue charts
     - over the years
     - per year compared to others
* comet change notifications

Rails
-----

* tests
     - full unit tests
     - better abstraction for JSON view tests
     - feature tests (cucumber)
* better JSON Query parsing
* full-text search
     - xapit
* update action
     - error response
* transactions + conflict handling
     - PUT + If-Unmodified-Since
     - 409 Conflict + merge
     - -> dojo.rpc.JsonRest
* authC, authZ
     - openid, oauth
     - authlogic
     - declarative authorization
* business logic
     - state machine for state dependent behavior
* controller subclass/mixin for JSON server

Dojo
----

* adapt to Dojo coding style
* error handling
* tests
     - DOH
     - Selenium
* data stores
     - correct partial and lazy loading
     - error handling
     - change notif from server + data notification API
* a11y
     - assign proper roles
* ensure that non-selected tabs are only loaded on demand
* editors
     - tab w/ icon for modified
* undo/back button
* offline?
* movie form
     - new movie
     - drag & drop for
         - people
         - awards
     - use JSON schema for setting up validations
* defore editing an object, check for updates
     - -> store mixin?
* Form 
     - define validations from schema
* transactions + conflict handling
* optimize stylesheets
