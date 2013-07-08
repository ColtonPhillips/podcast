def capitalize(str)
    return str.gsub(/-/, " ").split(/\s+/).map { |s| s.capitalize()}.join(" ")
end # function capitalize

def baseURL()
    return "http://www.secretmoonbase.net"
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
        return "#{episodesURL()}/#{fileName}"
    end # function relativeURI

    def absoluteURI()
        return "#{baseURL}/#{episodesURL()}/#{fileName}"
    end # function absoluteURI

    def defaultTitle()
        if fileName() =~ /^secretmoonbase_\d+_(.*)\.\w+$/
            return capitalize($1)
        end
    end # function defaultTitle

    def episodeNumber()
        if fileName() =~ /^secretmoonbase_(\d+)_.*\.\w+$/
            return $1
        end
    end # function episodeNumber

    def formatRSSItem()
        return <<HERE
        <item>
            <title>Episode #{episodeNumber()} - #{defaultTitle()}</title>
            <link>#{absoluteURI()}</link>
            <description><![CDATA[#{defaultTitle()}]]></description>

            <!--
            <guid isPermaLink="false"><![CDATA[45bcc35645be57e4bc9dcae4231700e5]]></guid>
            -->

            <media:thumbnail url="#{logoImage()}" />

            <pubDate>#{rssPubDate()}</pubDate>

            <itunes:explicit>no</itunes:explicit>
            <itunes:keywords />
            <itunes:subtitle />

            <!--
            <itunes:duration>2:25:34</itunes:duration>
            -->

            <itunes:duration>#{durationStr()}</itunes:duration>
            
            <author>operator@secretmoonbase.net (Secret Moon Base)</author>

            <media:content url="#{absoluteURI()}" fileSize="#{File::size(relativeURI())}" type="audio/mpeg" />

            <itunes:author>Secret Moon Base</itunes:author>
            <itunes:summary>A podcast ostensibly about video games</itunes:summary>

            <enclosure url="#{absoluteURI()}" length="#{File::size(relativeURI())}" type="audio/mpeg" />
        </item>
HERE
    end # function formatRSSItem

    def rssPubDate()
        return file().mtime().strftime("%a, %e %b %Y %H:%M:%S %z")
    end # function rssPubDate

    def formatHTMLLink()
        return "<a href=\"#{relativeURI()}\">Episode #{episodeNumber()} - #{defaultTitle()}</a>"
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
        if isEpisodeFile?(f)
            it = SMBEpisode.new(f)
            yield(it)
        end
    }
end # function eachEpisode
