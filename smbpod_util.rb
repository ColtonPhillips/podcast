ENV['GEM_HOME'] = File.expand_path('~u39693383/.gem/ruby/1.8')
require 'rubygems'
require 'mp3info'

def homePath()
    return File.expand_path("~u39693383")
end # function homePath

def capitalize(str)
    return str.gsub(/-/, " ").split(/\s+/).map { |s| s.capitalize()}.join(" ")
end # function capitalize

def sanitizeXml(str)
    return str.gsub('&', '&amp;').gsub('<', '&lt;')
end # function sanitizeXml

def baseURL()
    return "http://www.secretmoonbase.net"
end # function baseURL

def basePath()
    return File.expand_path("#{homePath()}/smbpod")
end # function baseURL

def episodesURL()
    return "res/episodes"
end # function baseURL

def imagesURL()
    return "res/img"
end # function imagesURL

def logoImage()
    return "#{baseURL()}/#{imagesURL()}/secretmoonbase_logo.png"
end # function logoImage

def isEpisodeFile?(filename)
    return (filename =~ /^secretmoonbase_/)
end # function isEpisodeFile?

class SMBEpisode
    def initialize(fileName)
        self.fileName = fileName
    end # ctor

    def relativeURI()
        return "#{episodesURL()}/#{fileName()}"
    end # function relativeURI

    def path()
        return "#{basePath()}/#{episodesURL()}/#{fileName}"
    end # function path

    def absoluteURI()
        return "#{baseURL}/#{episodesURL()}/#{fileName}"
    end # function absoluteURI

    def title()
        return "#{episodeName()}"
    end # function title

    def episodeName()
        t = nil

        if m = mp3Info()
            t = m.tag()['title']
        end

        if t == '' || t.nil?
            t = defaultEpisodeName()
        end

        return t
    end # function episodeName

    def defaultEpisodeName()
        if fileName() =~ /^secretmoonbase_\d+_(.*)\.\w+$/
            t = capitalize("#{$1}")
            return t
        end

        return nil
    end # function defaultEpisodeName

    def description()
        if m = mp3Info()
            d = m.tag()['comments']
            if d != '' && !d.nil?
                return d
            end
        end

        return title()
    end # function description

    def mp3Info()
        begin
            m = Mp3Info.new(path())
            return m
        rescue
            return nil
        end
    end # function mp3Info

    def episodeNumber()
        if fileName() =~ /^secretmoonbase_(\d+)_.*\.\w+$/
            return $1
        end
    end # function episodeNumber

    def formatRSSItem()
        fileSize = File::size(relativeURI())

        return <<HERE
        <item>
            <title>#{sanitizeXml(title())}</title>
            <link>#{absoluteURI()}</link>
            <description><![CDATA[#{sanitizeXml(description())}]]></description>
            <itunes:subtitle><![CDATA[#{sanitizeXml(description())}]]></itunes:subtitle>

            <media:content url="#{absoluteURI()}" fileSize="#{fileSize}" type="audio/mpeg" />
            <enclosure length="#{fileSize}" type="audio/mpeg" url="#{absoluteURI()}" />

            <media:thumbnail url="#{logoImage()}" />

            <pubDate>#{rssPubDate()}</pubDate>

            <itunes:explicit>yes</itunes:explicit>
            <itunes:keywords />

            <itunes:duration>#{durationStr()}</itunes:duration>
            
            <author>operator@secretmoonbase.net (Secret Moon Base)</author>

            <itunes:author>Secret Moon Base</itunes:author>
        </item>
HERE
    end # function formatRSSItem

    def rssPubDate()
        return file().mtime().strftime("%a, %e %b %Y %H:%M:%S %z")
    end # function rssPubDate

    def formatHTMLLink()
        return "<a href=\"#{relativeURI()}\">#{sanitizeXml(title())}</a>"
    end # function formatHTMLLink

    def file()
        return File::Stat.new(relativeURI())
    end # function file

    def durationSec()
        return (file().size() / 1000000) * 60
    end # function durationSec

    def durationStr()
        durSec = durationSec()

        hrs = (durSec / (60 * 60)).to_i()
        durSec = durSec - (hrs * 60 * 60)

        min = (durSec / 60).to_i()
        durSec = durSec - (min * 60)

        return sprintf("%0d:%02d:%02d", hrs, min, durSec)
    end # function durationStr

    attr_accessor :fileName
end # class SMBEpisode

def allEpisodes()
    return Dir.entries(episodesURL()).find_all() { |f| isEpisodeFile?(f) }.sort()
end # function allEpisodes

def latestEpisode()
    return SMBEpisode.new(allEpisodes().last())
end # function latestEpisode

def eachEpisode()
    allEpisodes().each() { |f|
        it = SMBEpisode.new(f)
        yield(it)
    }
end # function eachEpisode
