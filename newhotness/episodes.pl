#!/usr/bin/ruby
require 'smbpod_util'


print "Content-type: text/html\n\n"

print "<!DOCTYPE html>\n"
print "<html><body>\n"
print "<ul>\n"

eachEpisode() { |ep|
    print "<li>"
    print ep.formatHTMLLink()
    print "</li>\n"
}

print "</ul>\n"

print "</body></html>"
