require 'net/http'

module Hoiio
  def self.send_voice_call(num,msg)
    puts "Sending #{num}: #{msg}"
    Net::HTTP.get(URI(URI.escape("https://secure.hoiio.com/open/ivr/start/dial?app_id=#{ENV['HOIIO_APP']}&access_token=#{ENV['HOIIO_TOKEN']}&dest=#{num}&msg=#{msg}")))
  end
end
