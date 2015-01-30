automating account disabling

accounts are identified by their respective email

disabling webex
features
* multiple account disabling
* caches locally a copy of webex username and email for dictionary lookup
* if cached copy is > 1hr old, it will regenerate a new one

disabling yammer
features
* all of the features in webex plus:
* checks to see if access token is still good
* (if not) allows user to obtain new token to repair script


todo
* error checking for getting webex user data
* implement throttling so we dont go over limits for yammer api
