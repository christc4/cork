# Cork 

## What is cork?

Cork is an extremely lightweight static site generator, forked from  [werc](//werc.cat-v.org). Cork follows my software philosophy to a T, so many practices may be strange and displeasing to you.

## So what's the diff? 

What remains similar between the two, is the leveraging of plan9 core utils.

Where we diverge is organisation, and the complexities that follow different organising styles.

## Multiple sites?

Simply do this

## Why does Cork follow so many bad practices?

## How do I add...?

## Differences between cork and werc explained better

Werc by default, allows individual sites/subdomains to have their own _werc directory with the subdirectories: lib/, pub/, apps/. 

In short, lib/ was responsible for .tpl files that were responsible for headers, footers, the general layout and some other scripting behaviour.

pub/ allowed the user to store css or /pub could also be used.

It should be said, cork only has one central shell script, where everything is sourced.
