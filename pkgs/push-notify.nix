{ ruby, writeScriptBin }:
let
  keys = (import <secrets>).pushover;
in
writeScriptBin "push-notify" ''
  #! ${ruby}/bin/ruby

  require 'net/https'

  url = URI.parse('https://api.pushover.net/1/messages.json')
  req = Net::HTTP::Post.new(url.path)
  req.set_form_data({
    :token => '${keys.api_token}',
    :user => '${keys.user_key}',
    :title => ARGV[0],
    :message => ARGV[1],
  })
  res = Net::HTTP.new(url.host, url.port)
  res.use_ssl = true
  res.verify_mode = OpenSSL::SSL::VERIFY_PEER
  res.start {|http| http.request(req) }
''
