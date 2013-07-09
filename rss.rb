#!/usr/bin/ruby
# TODO: Understand it all 100% like a complete and utter bauss. 
# TODO: Get my ego in check
# TODO: De-SMBify it. change all the names to more coltony things. Chince-cast or some crap like that.
# TODO: enjoy my simple and fun podcast
require 'cpppod_util'


print "Content-type: application/rss+xml\n\n"
print "<rss xmlns:atom=\"http://www.w3.org/2005/Atom\" xmlns:cc=\"http://web.resource.org/cc/\" xmlns:itunes=\"http://www.itunes.com/dtds/podcast-1.0.dtd\" xmlns:media=\"http://search.yahoo.com/mrss/\" xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" version=\"2.0\">\n"

print "<channel>"

# TODO: format pubDate
# TODO: format lastBuildDate
# TODO: need "hub"?
# TODO: item description filled out from some other source
# TODO: guid needed?
# TODO: thumbnail
# TODO: item duration

print <<HERE
    <title>Colton Phillips Podcast</title>
    <link><![CDATA[http://www.coltonphillips.ca/]]></link>
    <description><![CDATA[Wow its the Colton Phillips Podcast!]]></description>
    <language>en</language>
    <copyright>Colton Phillips Podcast publishes under Creative Commons</copyright>
    <managingEditor>coltonjphillips@gmail.com</managingEditor>
    <pubDate>#{latestEpisode().rssPubDate()}</pubDate>
    <lastBuildDate>#{latestEpisode().rssPubDate()}</lastBuildDate>
    <generator>knutaf's rss thingy</generator>
    <docs>#{baseURL()}</docs>
    <itunes:author>Colton Phillips</itunes:author>
                                    
                                                    
                                                    
    <itunes:image href="#{logoImage()}" />
    <itunes:explicit>no</itunes:explicit>
    
    <itunes:summary>Wow! It's Colton! Who knew!</itunes:summary>
    <itunes:subtitle>video games and miscellanea</itunes:subtitle>
    <image>
        <url>#{logoImage()}</url>
        <title>Colton Phillips Podcast</title>
        <link><![CDATA[#{baseURL()}]]></link>
    </image>

        <atom10:link xmlns:atom10="http://www.w3.org/2005/Atom" rel="self" type="application/rss+xml" href="#{baseURL()}/rss.pl" />

<!--
<atom10:link xmlns:atom10="http://www.w3.org/2005/Atom" rel="hub" href="http://pubsubhubbub.appspot.com/" />
-->

<media:copyright>Colton Phillips publishes under Creative Commons</media:copyright>

<media:thumbnail url="#{logoImage()}" />

<media:keywords>video,games</media:keywords>
<media:category scheme="http://www.itunes.com/dtds/podcast-1.0.dtd">Video Games</media:category>

<itunes:owner>
    <itunes:email>coltonjphillips@gmail.com</itunes:email>
    <itunes:name>Colton Phillips Podcast</itunes:name>
</itunes:owner>

<itunes:keywords>video,games</itunes:keywords>
<itunes:category text="Games &amp; Hobbies">
    <itunes:category text="Video Games" />
</itunes:category>
HERE


eachEpisode() { |ep|
    print ep.formatRSSItem()
}

print <<HERE
<media:credit role="author">Colton Phillips Podcast</media:credit>
<media:rating>nonadult</media:rating>
<media:description type="plain">TODO: oh man. this is fun ain't it!</media:description>
HERE

print "</channel></rss>"
