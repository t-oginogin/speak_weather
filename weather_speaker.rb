require 'tts'
require './weather_information.rb'

class WeatherSpeaker
  attr_reader :weather_information

  WEATHER_KEY = /(てんき|天気)/
  UNBRELLA_KEY = /(かさ|傘)/
  TEMPERATURE_KEY = /(きおん|気温)/
  ULTRAVIOLET_KEY = /(しがいせん|紫外線)/
  THANKS_KEY = /(ありがとう)/

  VOICES = {
    '晴' => 'sunny.mp3',
    '晴後曇' => 'sunny_after_cloudiness.mp3',
    '晴後雨' => 'sunny_after_rain.mp3',
    '晴後雪' => 'sunny_after_snow.mp3',
    '晴時々曇' => 'sunny_sometimes_cloudiness.mp3',
    '晴時々雨' => 'sunny_sometimes_rain.mp3',
    '晴時々雪' => 'sunny_sometimes_snow.mp3',
    '曇' => 'cloudiness.mp3',
    '曇後晴' => 'cloudiness_after_sunny.mp3',
    '曇後雨' => 'cloudiness_after_rain.mp3',
    '曇後雪' => 'cloudiness_after_snow.mp3',
    '曇時々晴' => 'cloudiness_sometimes_sunny.mp3',
    '曇時々雨' => 'cloudiness_sometimes_rain.mp3',
    '曇時々雪' => 'cloudiness_sometimes_snow.mp3',
    '雨' => 'rain.mp3',
    '雨後晴' => 'rain_after_sunny.mp3',
    '雨後曇' => 'rain_after_cloudiness.mp3',
    '雨後雪' => 'rain_after_snow.mp3',
    '雨時々晴' => 'rain_sometimes_sunny.mp3',
    '雨時々曇' => 'rain_sometimes_cloudiness.mp3',
    '雨時々雪' => 'rain_sometimes_snow.mp3',
    '雪' => 'snow.mp3',
    '雪後晴' => 'snow_after_sunny.mp3',
    '雪後曇' => 'snow_after_cloudiness.mp3',
    '雪後雨' => 'snow_after_rain.mp3',
    '雪時々晴' => 'snow_sometimes_sunny.mp3',
    '雪時々曇' => 'snow_sometimes_cloudiness.mp3',
    '雪時々雨' => 'snow_sometimes_rain.mp3',
    '最高気温' => 'max.mp3',
    '最低気温' => 'min.mp3',
    '-' => 'minus.mp3',
    '+' => 'plus.mp3',
    '今日との差' => 'diff_today.mp3',
    '聞き取れへん' => 'not_understand.mp3',
    'もう一度' => 'again.mp3',
    'わからへん' => 'unknown.mp3',
  }

  UNBRELLA_VOICES = {
    '100' => 'unbrella_100.mp3',
    '90' => 'unbrella_90.mp3',
    '80' => 'unbrella_80.mp3',
    '70' => 'unbrella_70.mp3',
    '60' => 'unbrella_60.mp3',
    '50' => 'unbrella_50.mp3',
    '40' => 'unbrella_40.mp3',
    '30' => 'unbrella_30.mp3',
    '20' => 'unbrella_20.mp3',
    '10' => 'unbrella_10.mp3',
    '0' => 'unbrella_0.mp3',
  }

  ULTRAVIOLET_VOICES = {
    'きわめて強い' => 'ultraviolet_5.mp3',
    '非常に強い' => 'ultraviolet_4.mp3',
    '強い' => 'ultraviolet_3.mp3',
    'やや強い' => 'ultraviolet_2.mp3',
    '弱い' => 'ultraviolet_1.mp3',
  }

  THANKS_VOICES = {
    '無理せんように' => 'not_be_unreasonable.mp3',
    'また聞いて' => 'your_welcome.mp3',
    'リフレッシュ' => 'refresh.mp3',
    'あと1日' => 'before_holiday.mp3',
  }

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
        speak_max_min_temperature
      when ULTRAVIOLET_KEY
        speak_ultraviolet_comment
      when THANKS_KEY
        speak_thanks
      else
        speak_unknown
      end
    end
  end

  private

  def speak_weather
    weather = weather_information.weather
    word = weather[:tomorrow]

    matched_words = word.match(/(晴|曇|雨|雪)+(後|時々)?(晴|曇|雨|雪)?/)
    if matched_words
      play VOICES[matched_words[0]]
    end
  end

  def speak_unbrella_comment
    unbrella_rates = weather_information.unbrella_rate

    play UNBRELLA_VOICES[unbrella_rates[:tomorrow]] if unbrella_rates
  end

  def speak_max_min_temperature
    temp = weather_information.temperature
    matched_words = temp[:tomorrow][:max][:temp].match(/(\+|-)?(\d+)/)
    return if matched_words.nil?

    play VOICES['最高気温']
    speak_tempareture(matched_words[1], matched_words[2])

    play VOICES['今日との差']
    matched_words = temp[:tomorrow][:max][:diff].match(/(\+|-)?(\d+)/)
    if matched_words
      speak_tempareture(matched_words[1], matched_words[2])
    else
      play VOICES['わからへん']
    end
  end

  def speak_tempareture(sign, temp)
    play VOICES['-'] if sign == '-'
    play VOICES['+'] if sign == '+'

    case temp.to_i
    when 0..39
      play "#{temp}.mp3"
    else
      play VOICES['わからへん']
    end
  end

  def speak_ultraviolet_comment
    ultraviolet_levels = weather_information.ultraviolet_level
    play ULTRAVIOLET_VOICES[ultraviolet_levels[:tomorrow]] if ultraviolet_levels
  end

  def speak_thanks
    words = %w(無理せんように また聞いて リフレッシュ)
    words << 'あと1日' if Time.now.strftime('%A') == 'Thursday'
    word = words.sample
    play THANKS_VOICES[word]
  end

  def speak_unknown
    word = %w(聞き取れへん もう一度 わからへん).sample
    play VOICES[word]
  end

  def play(file)
    `amixer sset Mic 0 -c 0` # しゃべる声に反応してしまうためマイクをミュート
    `mpg123 -q voices/#{file}` if file
    `amixer sset Mic 62 -c 0`
  end
end
