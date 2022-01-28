# screentime

This system provides budgets of screentime minutes
and enforces that managed accounts will be logged
out automatically when their budget is zero.

The budget is accessed through a tiny web service that
uses bash scripts via CGI interface.

Bash scripts to add or remove minutes to the budget 
are provided as well.

On Windows machines, a background service is used to
monitor logged in users and decrease their budget as
mimnutes pass. The service is basically a looping 
powershell script that sleep for a minute at a time.

