# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_moviedb_session',
  :secret      => '9140bf444cac244373b9fcf58fc7c767339b26aafa4e4adeca78752abf3cb8fba54f25158222063121ad3cbdf9701f4939a887d19b9534b8f482da7bf6381f7a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
