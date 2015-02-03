automating account disabling


accounts are identified by their respective email

<u>features</u>

* multiple account disabling
* caches locally a copy of username and email for dictionary lookup
* if cached copy is > 1hr old or doesn't exist, it will regenerate a new one
* to disable lync accounts, uses nagios nrpe to run a powershell script on the lync server

<u>list of supported services</u>

* webex
* yammer
* lync (in progress)


todo

* error checking for getting webex user data
* implement throttling so we dont go over limits for yammer api
