require 'tts'
require './weather_information.rb'

class WeatherSpeaker
  attr_reader :weather_information

  WEATHER_KEY = /(てんき|天気|はれ|晴れ|くもり|曇り|あめ|雨)/
  UNBRELLA_KEY = /(かさ|傘)/
  TEMPERATURE_KEY = /(きおん|気温|おんど|温度|あつい|暑い|さむい|寒い)/
  ULTRAVIOLET_KEY = /(しがいせん|紫外線|ひざし|日差し)/

  def initialize(weather_information)
    @weather_information = weather_information
  end

  def speak(word)
    if word != ''
      case word
      when WEATHER_KEY
        speak_weather
      when UNBRELLA_KEY
        speak_unbrella_comment
      when TEMPERATURE_KEY
        speak_temperature
      when ULTRAVIOLET_KEY
        speak_ultraviolet_comment
      else
        speak_unknown
      end
    end
  end

  private

  def speak_weather
    weather = weather_information.weather
    speak_word "天気は#{weather[:tomorrow]}っす。"
  end

  def speak_unbrella_comment
    unbrella_comment = weather_information.unbrella_comment
    speak_word "#{unbrella_comment[:tomorrow]}っす。"
  end

  def speak_temperature
    temp = weather_information.temperature
    content = "最高気温は#{temp[:tomorrow][:max][:temp]}度っす。"
    content = "#{content}本日との差は#{temp[:tomorrow][:max][:diff]}度っす。"
    content = "#{content}最低気温は#{temp[:tomorrow][:min][:temp]}度っす。"
    content = "#{content}本日との差は#{temp[:tomorrow][:min][:diff]}度っす。"
    speak_word content
  end

  def speak_ultraviolet_comment
    ultraviolet_comment = weather_information.ultraviolet_comment
    speak_word "#{ultraviolet_comment[:tomorrow]}っす。"
  end

  def speak_unknown
    speak_word "聞き取れなかったっす。"
  end

  def speak_word(word)
    puts word
#    return # word.playで503エラーが発生するため
    word.play 'ja'
  end
end
