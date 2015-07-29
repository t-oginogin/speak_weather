require 'nokogiri'
require './julius_connector.rb'
require './weather_information.rb'
require './weather_speaker.rb'

class SpeakWeather
  def start(city)
    socket = JuliusConnector.open
    return if socket.nil?

    weather_information = WeatherInformation.new city
    speaker = WeatherSpeaker.new weather_information
    source = ""

    while true
      ret = IO::select [socket]
      ret[0].each do |sock|
        source += sock.recv 4096
        word = parse_word source
        if word
          speaker.speak word
          source = ''
        end
      end
    end
  end

  private

  def parse_word(source)
    if source[-2..source.size] == ".\n"
      source.gsub! /\.\n/, ''
      xml = Nokogiri source
      return xml.xpath('//RECOGOUT//SHYPO//WHYPO').inject('') {|ws, w| ws + w['WORD'] }
    end
    nil
  end
end

KOBE = 6310
SpeakWeather.new.start KOBE
