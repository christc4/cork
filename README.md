# Cork 

## What is cork?

Cork is an extremely lightweight static site generator, forked from  [werc](//werc.cat-v.org). Cork follows my software philosophy to a T, so many practices may be strange and displeasing to you.

## Features

- Written in RC shell
	- plan9 coreutils are faster and more performant than GNU
- Minimal as can be

	- unlike the source for other static site generators, where you cannot see the forest for the trees, cork source is easy to follow 
	
## Lack of features and how to add them

## So what's the diff? 

What remains similar between the two, is the leveraging of plan9 core utils.

Where we diverge is organisation, and the complexities that follow different organising styles.

## Multiple sites?

Since cork sources one central script, in your webserver configuration file, copy the default cork script and change the site variable

```
server "example.org" {
	listen on * port 80
	connection request timeout 4
	location found "/*" {
		root "/cork/example.org"
	}
	location not found "/*" {
		root "/"
		fastcgi {
			param PLAN9 "/usr/local/plan9"
			param SCRIPT_FILENAME "/cork/example.org.rc"
			socket "/run/slowcgi.sock"
		}
	}
}
```

```
server "test.net" {
	listen on * port 80
	connection request timeout 4
	location found "/*" {
		root "/cork/test.net"
	}
	location not found "/*" {
		root "/"
		fastcgi {
			param PLAN9 "/usr/local/plan9"
			param SCRIPT_FILENAME "/cork/test.net.rc"
			socket "/run/slowcgi.sock"
		}
	}
}
```





## Why does Cork follow so many bad practices?

## How do I add...?

## Differences between cork and werc explained better

Werc by default, allows individual sites/subdomains to have their own _werc directory with the subdirectories: lib/, pub/, apps/. 

In short, lib/ was responsible for .tpl files that were responsible for headers, footers, the general layout and some other scripting behaviour.

pub/ allowed the user to store css or /pub could also be used.

It should be said, cork only has one central shell script, where everything is sourced.
