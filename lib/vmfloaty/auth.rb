require 'faraday'
require 'vmfloaty/http'

class Auth
  def self.get_token(user, url, password)
    conn = Http.get_conn(url)

    #resp = conn.post do |req|
    #        req.url '/v1/token'
    #        req.headers['Content-Type'] = 'application/json'
    #        req.user = user
    #      end
    # if ok: true, return token
    puts 'Got token'
  end

  def self.delete_token(user, token)
    conn = Http.get_conn(url)
  end
end