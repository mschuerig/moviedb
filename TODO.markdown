
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
    - controller tests
        - include update conflicts
    - better abstraction for JSON view tests
    - feature tests (cucumber)
* Role
    - actor: as
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

Dojo
----

* adapt to Dojo coding style
* error handling
* tests
    - DOH
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
    - drag & drop for
        - people
        - awards
* before editing an object, check for updates
    - -> store mixin?
* Form
    - submit button
        - distinguish Create/Save
        - enable only when form modified
        - enable only when form valid
    - define validations from schema
* transactions + conflict handling
* optimize stylesheets
