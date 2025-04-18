# cork

A retired super-small static-site generator written in RC shell, compatible on any server with the Plan9 core-utils installed

Originally a fork of [werc](http://werc.cat-v.org), Cork took its own software direction, focusing on delivering one *singular* small and tidy shell script to work with an accompanying Markdown-to-HTML generator.

## Features

- Statically generated sidebar with directory listing  
  - Can support highlighting of parent directories and current file  
- Performant  
  - Plan9 core-utils outperform GNU/BSD  
- Everything is scriptable  
  - Small codebase + compatibility with werc

## Install

Cork has only been tested with OpenBSD's native webserver, `httpd`. In theory, the [following guides](http://werc.cat-v.org/docs/web-server-setup/) should be compatible.

> If you don't want the full-blown plan9port, try **9base**.

## news

- **2025/01/02** – Support for horizontal sidebar added  
- **2024/12/28** – Rendering issue solved for TUI browsers  
  - Contrary to belief, `<!doctype>` and `<html>` tags are necessary for full compatibility  
  - HTML headers needed to specify `Content-Type`  
