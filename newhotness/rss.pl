#!/usr/bin/ruby
require 'smbpod_util'


print "Content-type: application/rss+xml\n\n"
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
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
    <title>Secret Moon Base Podcast</title>
    <link><![CDATA[http://www.secretmoonbase.net/]]></link>
    <atom:link rel="self" type="application/rss+xml" href="#{baseURL()}/rss.pl" />
    <description><![CDATA[Join Destructoid community members Corduroy Turtle (@17wizards), knutaf (@_knutaf) and Occam's Electric Toothbrush (@Tee_Ball_Bat) as they attempt to find the middle ground between intelligent video game discourse and their completely absurd deviations. Nothing is sacred in the Secret Moon Base!  Children and sensitive adults beware!]]></description>
    <language>en</language>
    <copyright>Secret Moon Base publishes under Creative Commons</copyright>
    <managingEditor>operator@secretmoonbase.net</managingEditor>
    <pubDate>#{latestEpisode().rssPubDate()}</pubDate>
    <lastBuildDate>#{latestEpisode().rssPubDate()}</lastBuildDate>
    <generator>knutaf's rss thingy</generator>
    <docs>#{baseURL()}</docs>

    <itunes:author>Secret Moon Base</itunes:author>
    <itunes:owner>
            <itunes:name><![CDATA[knutaf]]></itunes:name>
            <itunes:email>operator@secretmoonbase.net</itunes:email>
    </itunes:owner>
                                    
    <itunes:explicit>yes</itunes:explicit>
    
    <itunes:summary><![CDATA[Secret Moon Base, a podcast ostensibly about video games]]></itunes:summary>
    <itunes:subtitle><![CDATA[video games and miscellanea]]></itunes:subtitle>

    <itunes:image href="#{logoImage()}" />
    <image>
        <url>#{logoImage()}</url>
        <title>Secret Moon Base</title>
        <link><![CDATA[#{baseURL()}]]></link>
    </image>

<!--
<atom10:link xmlns:atom10="http://www.w3.org/2005/Atom" rel="hub" href="http://pubsubhubbub.appspot.com/" />
-->

<media:copyright>Secret Moon Base publishes under Creative Commons</media:copyright>

<media:thumbnail url="#{logoImage()}" />

<media:keywords>sercet,mono,bsae,secet,secert,screte</media:keywords>
<media:category scheme="http://www.itunes.com/dtds/podcast-1.0.dtd">Video Games</media:category>

<itunes:keywords>video,games</itunes:keywords>
<itunes:category text="Games &amp; Hobbies">
    <itunes:category text="Video Games" />
</itunes:category>
HERE


eachEpisode() { |ep|
    print ep.formatRSSItem()
}

print <<HERE
<media:credit role="author">Secret Moon Base</media:credit>
<media:rating>nonadult</media:rating>
<media:description><![CDATA[Join Destructoid community members Corduroy Turtle (@17wizards), knutaf (@_knutaf) and Occam's Electric Toothbrush (@Tee_Ball_Bat) as they attempt to find the middle ground between intelligent video game discourse and their completely absurd deviations. Nothing is sacred in the Secret Moon Base!  Children and sensitive adults beware!]]></media:description>
HERE

print "</channel></rss>"
