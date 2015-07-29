require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'

class WeatherInformation
  attr_reader :city

  def initialize(city)
    @city = city
  end

  def weather
    xml = forecast
    weathers = xml.xpath("//div[@class='forecastCity']//p[@class='pict']/text()")
    today_weather = weathers[0].to_s
    tomorrow_weather = weathers[1].to_s
    {today: today_weather, tomorrow: tomorrow_weather}
  end

  def temperature
    xml = forecast

    temps = xml.xpath("//div[@class='forecastCity']//ul[@class='temp']//li/em/text()")
    diffs = xml.xpath("//div[@class='forecastCity']//ul[@class='temp']//li/text()")

    today_max_temp = temps[0].to_s
    today_min_temp = temps[1].to_s
    tomorrow_max_temp = temps[2].to_s
    tomorrow_min_temp = temps[3].to_s

    regexp = /\[([\+\-\d]+)\]/
    today_max_diff = diffs[0].to_s.match(regexp)[1]
    today_min_diff = diffs[1].to_s.match(regexp)[1]
    tomorrow_max_diff = diffs[2].to_s.match(regexp)[1]
    tomorrow_min_diff = diffs[3].to_s.match(regexp)[1]

    {
      today: {
        max: {temp: today_max_temp, diff: today_max_diff},
        min: {temp: today_min_temp, diff: today_min_diff}
      },
      tomorrow: {
        max: {temp: tomorrow_max_temp, diff: tomorrow_max_diff},
        min: {temp: tomorrow_min_temp, diff: tomorrow_min_diff}
      }
    }
  end

  def unbrella_comment
    xml = metrics
    unbrella_comments = xml.xpath("//*[@id='explst']//tr[th='傘']//dd[2]//text()")
    today_unbrella_comment = unbrella_comments[0].to_s
    tomorrow_unbrella_comment = unbrella_comments[1].to_s
    {today: today_unbrella_comment, tomorrow: tomorrow_unbrella_comment}
  end

  def ultraviolet_comment
    xml = metrics
    ultraviolet_comments = xml.xpath("//*[@id='explst']//tr[th='紫外線']//dd[2]//text()")
    today_ultraviolet_comment = ultraviolet_comments[0].to_s
    tomorrow_ultraviolet_comment = ultraviolet_comments[1].to_s
    {today: today_ultraviolet_comment, tomorrow: tomorrow_ultraviolet_comment}
  end

  private

  def forecast
    uri = URI.parse("http://weather.yahoo.co.jp/weather/jp/28/#{self.city}.html")
    source = Net::HTTP.get(uri)
    Nokogiri source
  end

  def metrics
    uri = URI.parse("http://weather.yahoo.co.jp/weather/jp/expo/#{self.city}/")
    source = Net::HTTP.get(uri)
    Nokogiri source
  end

end
