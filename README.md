Welcome to our OPL Project, Will They Feed!

Josh:
I've gotten most of the parsing to work, having trouble with a particularly nasty hash-table-in-a-hash-table-in-a-hash-table (hashseption) but I have it working so entering a summoner name will sanitize it, pass it to the api, then pull out certain stats(still waiting on a stack overflow answer to get league-division and league-tier) and print them out.

To use it - simply type a summoner name after running the racket file.  If you don't know any summoner names, try "raker" or "forcinit".  The inputs are checked so even if the capitalization or spacing it wrong, it will still get you the right information (ex. 'FORCIN it' and 'forC init' and 'forcinit' all correctly display the summoner information for 'F O R C I N it')
