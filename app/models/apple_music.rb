class AppleMusic
  def self.token
    private_key = ENV['apple_private_key']

    keyId = ENV['apple_app_key']
    teamId = ENV['apple_team_key']
    hours_to_live = 24 * 180

    time_now = Time.now.to_i
    time_expired = Time.now.to_i + hours_to_live * 3600
    algorithm = 'ES256'

    headers = {
      'typ': 'JWT',
      'kid': keyId
    }

    payload = {
      'iss': teamId,
      'exp': time_expired,
      'iat': time_now
    }

    ecdsa_key = OpenSSL::PKey::EC.new private_key
    ecdsa_key.check_key

    JWT.encode payload, ecdsa_key, algorithm, header_fields=headers
  end
end