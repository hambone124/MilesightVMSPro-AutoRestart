# MilesightVMSPro-AutoRestart
Automatically restarts Milesight VMS Pro server when it silently loses connection.

Checks if the server is listening on port 33606 (default) every 5 seconds. If the server is not listening on port 33606, this script will terminate the server process and attempt to start a new server process.
