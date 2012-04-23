This is a ruby command line twitter client.

It depends on a whole bunch of gems being installed. Something like this should help:

	sudo gem install twitter oauth net-netrc launchy

 * TODO - check this list

It also depends on being able to open a browser to authenticate occasionally, so it's not entirely command line. I think that's a limitation of OAuth but I could be wrong.

I have this set up in my command prompt by adding to my `.profile` (and with the `ct` script in my `$PATH`)

	export PROMPT_COMMAND="ct; $PROMPT_COMMAND"
