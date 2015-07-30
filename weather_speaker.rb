require 'tts'
require './weather_information.rb'

class WeatherSpeaker
  attr_reader :weather_information

  WEATHER_KEY = /(てんき|天気)/
  UNBRELLA_KEY = /(かさ|傘)/
  TEMPERATURE_KEY = /(きおん|気温)/
  ULTRAVIOLET_KEY = /(しがいせん|紫外線)/

  VOICES = {
    '晴' => 'sunny.mp3',
    '曇' => 'cloudiness.mp3',
    '雨' => 'rain.mp3',
    '雪' => 'snow.mp3',
    '後' => 'after.mp3',
    '時々' => 'sometimes.mp3',
    '最高気温' => 'max.mp3',
    '最低気温' => 'min.mp3',
    '0' => 'zero.mp3',
    '1' => 'one.mp3',
    '2' => 'two.mp3',
    '3' => 'three.mp3',
    '4' => 'four.mp3',
    '5' => 'five.mp3',
    '6' => 'six.mp3',
    '7' => 'seven.mp3',
    '8' => 'eight.mp3',
    '9' => 'nine.mp3',
    '10' => 'ten.mp3',
    '度' => 'degree.mp3',
    '-' => 'minus.mp3',
    '+' => 'plus.mp3',
    'っす' => 'su.mp3',
    '今日との差' => 'diff_today.mp3',
    '聞き取れなかった' => 'not_understand.mp3',
    'もう一度' => 'again.mp3',
    'わからない' => 'unknown.mp3',
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
      play VOICES[matched_words[1]]
      play VOICES[matched_words[2]]
      play VOICES[matched_words[3]]
      play VOICES['っす']
    end
  end

  def speak_unbrella_comment
    unbrella_rates = weather_information.unbrella_rate

    play UNBRELLA_VOICES[unbrella_rates[:tomorrow]] if unbrella_rates
  end

  def speak_max_min_temperature
    temp = weather_information.temperature
    matched_words = temp[:tomorrow][:max][:temp].match(/(\+|-)?(\d+)/)
    play VOICES['最高気温']
    speak_tempareture(matched_words[1], matched_words[2])

    play VOICES['今日との差']
    matched_words = temp[:tomorrow][:max][:diff].match(/(\+|-)?(\d+)/)
    speak_tempareture(matched_words[1], matched_words[2])
  end

  def speak_tempareture(sign, temp)
    play VOICES['-'] if sign == '-'
    play VOICES['+'] if sign == '+'

    case temp.to_i
    when 0..9
      play VOICES[temp]
    when 10
      play VOICES['10']
    when 11..19
      matched_temp = temp.match(/(\d)(\d)/)
      play VOICES['10']
      play VOICES[matched_temp[2]]
    else
      matched_temp = temp.match(/(\d)(\d)/)
      play VOICES[matched_temp[1]]
      play VOICES['10']
      play VOICES[matched_temp[2]]
    end

    play VOICES['度']
    play VOICES['っす']
  end

  def speak_ultraviolet_comment
    ultraviolet_levels = weather_information.ultraviolet_level
    play ULTRAVIOLET_VOICES[ultraviolet_levels[:tomorrow]] if ultraviolet_levels
  end

  def speak_unknown
    word = %w(聞き取れなかった もう一度 わからない).sample
    play VOICES[word]
  end

  def play(file)
    `mixer sset Mic 0 -c 0` # しゃべる声に反応してしまうためマイクをミュート
    `mpg123 -q voices/#{file}` if file
    `mixer sset Mic 62 -c 0`
  end
end
