def capitalize(str)
    return str.gsub(/-/, " ").split(/\s+/).map { |s| s.capitalize()}.join(" ")
end 

def baseURL()
    return "http://www.secretmoonbase.net"
end 

def episodesURL()
    return "res/episodes"
end 

def imagesURL()
    return "res/img"
end 

def logoImage()
    return "#{baseURL()}/#{imagesURL()}/secretmoonbase_logo.png"
end 

def isEpisodeFile?(filename)
    return (filename =~ /^secretmoonbase_/)
end 

class SMBEpisode
    def initialize(fileName)
        self.fileName = fileName
    end 

    def relativeURI()
        return "#{episodesURL()}/#{fileName}"
    end 

    def absoluteURI()
        return "#{baseURL}/#{episodesURL()}/#{fileName}"
    end 

    def defaultTitle()
        if fileName() =~ /^secretmoonbase_\d+_(.*)\.\w+$/
            return capitalize($1)
        end
    end 

    def episodeNumber()
        if fileName() =~ /^secretmoonbase_(\d+)_.*\.\w+$/
            return $1
        end
    end 

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
    end 

    def rssPubDate()
        return file().mtime().strftime("%a, %e %b %Y %H:%M:%S %z")
    end 

    def formatHTMLLink()
        return "<a href=\"#{relativeURI()}\">Episode #{episodeNumber()} - #{defaultTitle()}</a>"
    end 

    def file()
        return File::Stat.new(relativeURI())
    end 

    def durationSec()
        return (file().size() / 1000000) * 60
    end 

    def durationStr()
        durSec = durationSec()

        hrs = (durSec / (60 * 60)).to_i()
        durSec = durSec - (hrs * 60 * 60)

        min = (durSec / 60).to_i()
        durSec = durSec - (min * 60)

        return sprintf("%0d:%02d:%02d", hrs, min, durSec)
    end 

    attr_accessor :fileName
end 

def allEpisodes()
    return Dir.entries(episodesURL()).find_all() { |f| isEpisodeFile?(f) }.sort()
end 

def latestEpisode()
    return SMBEpisode.new(allEpisodes().last())
end 

def eachEpisode()
    allEpisodes().each() { |f|
        if isEpisodeFile?(f)
            it = SMBEpisode.new(f)
            yield(it)
        end
    }
end 
