#!/bin/awk -f
function eschtml(t) { gsub("&", "\\&amp;", t); gsub("<", "\\&lt;", t); return t; }; function oprint(t){ if(nr == 0) otext = otext t; else otext = otext t; }; function subref(id){ for(; nr > 0 && sub("<<" id, ref[id], otext); nr--); if(nr == 0 && otext) otext = otext; }; function nextil(t){ if(!match(t, /[<&\[*_\\-]|(\!\[)/)) return t; t1 = substr(t, 1, RSTART - 1); tag = substr(t, RSTART, RLENGTH); t2 = substr(t, RSTART + RLENGTH); if(ilcode && tag != "") return eschtml(t1 tag) nextil(t2); if(tag == "\\"){ if(match(t2, /^[\\*_{}\[\]()#+\-\.!]/)){ tag = substr(t2, 1, 1); t2 = substr(t2, 2); } return t1 tag nextil(t2); } if(tag == "-"){ if(sub(/^-/, "", t2)) tag = "&#8212;"; return t1 tag nextil(t2); } if(tag == "<"){ if(match(t2, /^[^ ]+[\.@][^ ]+>/)){ url = eschtml(substr(t2, 1, RLENGTH - 1)); t2 = substr(t2, RLENGTH + 1); linktext = url; return t1 "<a href=\"" url "\">" linktext "</a>" nextil(t2); } if(match(t2, /^[A-Za-z\/!][^>]*>/)){ tag = tag substr(t2, RSTART, RLENGTH); t2 = substr(t2, RLENGTH + 1); return t1 tag nextil(t2); } return t1 "&lt;" nextil(t2); } if(tag == "["){ if(!match(t2, /(\[.*\])|(\(.*\))/)) return t1 tag nextil(t2); match(t2, /^[^\]]*(\[[^\]]*\][^\]]*)*/); linktext = substr(t2, 1, RLENGTH); t2 = substr(t2, RLENGTH + 2); if(match(t2, /^\(/)){ match(t2, /^[^\)]+(\([^\)]+\)[^\)]*)*/); url = substr(t2, 2, RLENGTH - 1); pt2 = substr(t2, RLENGTH + 2); title = ""; if(match(url, /[ ]+\".*\"[ ]*$/)){ title = substr(url, RSTART, RLENGTH); url = substr(url, 1, RSTART - 1); match(title, /\".*\"/); title = " title=\"" substr(title, RSTART + 1, RLENGTH - 2) "\""; } if(match(url, /^<.*>$/)) url = substr(url, 2, RLENGTH - 2); url = eschtml(url); return t1 "<a href=\"" url "\"" title ">" nextil(linktext) "</a>" nextil(pt2); } } if(match(tag, /[*_]/)){ ntag = tag; if(sub("^" tag, "", t2)){ if(stag[ns] == tag && match(t2, "^" tag)) t2 = tag t2; else ntag = tag tag; } n = length(ntag); tag = (n == 2) ? "b" : "em"; if(match(t1, / $/) && match(t2, /^ /)) return t1 tag nextil(t2); if(stag[ns] == ntag){ tag = "/" tag; ns--; } else stag[++ns] = ntag; tag = "<" tag ">"; return t1 tag nextil(t2); } }; function inline(t){ ilcode = 0; ilcode2 = 0; ns = 0; return nextil(t); }; function printp(tag){ if(!match(text, /^[ ]*$/)){ text = inline(text); if(tag != "") oprint("<" tag ">" text "</" tag ">"); else oprint(text); } text = ""; }

# Early return function printp(tag){if(match(text,/^[ ]*$/)){text="";return}text=inline(text);if(tag=="p"){oprint("<"tag">"text)}else{oprint("<"tag">"text"</"tag">")};text=""}
# ELSE function printp(tag){if(!match(text,/^[ ]*$/)){text=inline(text);if(tag=="p"){oprint("<"tag">"text)}else{oprint("<"tag">"text"</"tag">")}}text=""}

BEGIN{blank=0;code=0;hr=0;html=0;nl=0;nr=0;otext="<article><a href=/search.html>search</a> <a href=/blog/me/reach>reach</a>";text="";par="p";}
# html
!html && /^<(blockquote|div|h[1-6r]|\
ol|p|pre|table|ul|!--)/ {
    for(; !text && block[nl] == "blockquote"; nl--)
	oprint("</blockquote>");
    match($0, /^<(blockquote|center|div|h[1-6r]|\
ol|p|pre|table|ul|!--)/);
    htag = substr($0, 2, RLENGTH - 1);
    if(!match($0, "(<\\/" htag ">)|((^<hr ?\\/?)|(--)>$)"))
	html = 1;
    if(html && match($0, /^<hr/))
	hr = 1;
    oprint($0);
    next;
}
html && (/(^<\/(blockquote|div|h[1-6r]|\
ol|p|pre|table|ul).*)|(--)>$/ ||
(hr && />$/)) {
    html = 0;
    hr = 0;
    oprint($0);
    next;
}
html {
    oprint($0);
    next;
}
{
    for(nnl = 0; nnl < nl; nnl++)
	if((match(block[nnl + 1], /[ou]l/) && !sub(/^(    |	)/, "")) || \
	(block[nnl + 1] == "blockquote" && !sub(/^> ?/, "")))
	    break;
}
nnl < nl && !blank && text && ! /^ ? ? ?([*+-]|([0-9]+\.)+)( +|	)/ { nnl = nl; }
{ 
    while(sub(/^> /, ""))
	nblock[++nnl] = "blockquote";
}
{ hr = 0; }
(blank || (!text && !code)) && /^ ? ? ?([-*_][ 	]*)([-*_][ 	]*)([-*_][ 	]*)+$/ {
    if(code){
	oprint("</pre>");
	code = 0;
    }
    blank = 0;
    nnl = 0;
    hr = 1;
}
block[nl] ~ /[ou]l/ && /^$/ {
    blank = 1;
    next;
}
{ newli = 0; }
!hr && (nnl != nl || !text || block[nl] ~ /[ou]l/) && /^ ? ? ?[*+-]( +|	)/ {
    sub(/^ ? ? ?[*+-]( +|	)/, "");
    nnl++;
    nblock[nnl] = "ul";
    newli = 1;
}
(nnl != nl || !text || block[nl] ~ /[ou]l/) && /^ ? ? ?([0-9]+\.)+( +|	)/ {
    sub(/^ ? ? ?([0-9]+\.)+( +|	)/, "");
    nnl++;
    nblock[nnl] = "ol";
    newli = 1;
}
newli { 
    if(blank && nnl == nl && !par)
	par = "p";
    blank = 0;
    printp(par);
    if(nnl == nl && block[nl] == nblock[nl])
	 oprint("</li><li>");
}
blank && ! /^$/ {
    if(match(block[nnl], /[ou]l/) && !par)
	par = "p";
    printp(par);
    par = "p";
    blank = 0;
}
nnl != nl || nblock[nl] != block[nl] {
    if(code){
	oprint("</pre>");
	code = 0;
    }
    printp(par);
    b = (nnl > nl) ? nblock[nnl] : block[nl];
    par = (match(b, /[ou]l/)) ? "" : "p";
}
nnl < nl || (nnl == nl && nblock[nl] != block[nl]) {
    for(; nl > nnl || (nnl == nl && pblock[nl] != block[nl]); nl--){
	 if(match(block[nl], /[ou]l/))
	    oprint("</li>");
	oprint("</" block[nl] ">");
    }
}
nnl > nl {
    for(; nl < nnl; nl++){
	block[nl + 1] = nblock[nl + 1];
	oprint("<" block[nl + 1] ">");
	if(match(block[nl + 1], /[ou]l/))
	    oprint("<li>");
    }
}
code && /^$/ { 
    if(blank)
	oprint("");
    blank = 1;
    next;
}
!text && sub(/^(	|    )/, "") {
    if(blank)
	oprint("");
    blank = 0;
    if(!code)
	oprint("<pre>");
    code = 1;
    $0 = eschtml($0);
    oprint($0);
    next;
}
code { oprint("</pre>"); code = 0 }
/^#+/ && (!newli || par=="p" || /^##/) {
    for(n = 0; n < 6 && sub(/^# */, ""); n++)
	sub(/#$/, "");
    par = "h" n;
}
/^$/ {
    printp(par);
    par = "p";
    next;
}
{ text = (text ? text " " : "") $0; }
END{if(code){oprint("</pre>");code=0;}printp(par);for(;nl>0;nl--){if(match(block[nl],/[ou]l/))oprint("</li>");oprint("</" block[nl] ">");}gsub(/\n/,"",otext);oprint("<br><a href=../>back</a>");printf(otext);}
