# MilesightVMSPro-AutoRestart
Automatically restarts Milesight VMS Pro server when it silently loses connection.

Checks if server is listening on port 33606 (default). If the server is not listening on port 33606, this script will terminate the server process and attempt to start a new server process.
