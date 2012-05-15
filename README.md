This is a ruby command line twitter client.

It depends on a whole bunch of gems being installed. Something like this should help:

	sudo gem install twitter oauth net-netrc launchy

 * TODO - check this list

It also depends on being able to open a browser to authenticate occasionally, so it's not entirely command line. I think that's a limitation of OAuth but I could be wrong.

I have this set up in my command prompt by adding to my `.profile` (and with the `ct` script in my `$PATH`)

	export PROMPT_COMMAND="ct; $PROMPT_COMMAND"

User Colors
-----------
If you would like to have customized colors for some users, copy the `sample.ctseen` file to `.ctseen` in your home directory. Edit the users under the `:colors` heading. The numbers are "ANSI Color codes":http://en.wikipedia.org/wiki/ANSI_escape_code#Colors (note, I have a TODO to change this to make more colors available).

Note that the `.ctseen` file is modified by the client each time it runs, since it is also used to store which messages were last seen etc.
