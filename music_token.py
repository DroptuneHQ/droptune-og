# requires pyjwt (https://pyjwt.readthedocs.io/en/latest/)
# pip install pyjwt


import datetime
import jwt


secret = """-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgtWNkszuK9QL9LbjB
Jtkv2zVmqHhl3TgFVH5ZIrPztv+gCgYIKoZIzj0DAQehRANCAASLkUB82u5Xw+Ac
5+tyLUdKnn+2skXJSQmCYVklZhroaW6n3MFRpyNoohtPh8cbe3ArvRNCRl437r43
Yr5ZRaqI
-----END PRIVATE KEY-----"""
keyId = "XXLB9ZJRG3"
teamId = "W33JZPPPFN"
alg = 'ES256'

time_now = datetime.datetime.now()
time_expired = datetime.datetime.now() + datetime.timedelta(hours=12)

headers = {
  "alg": alg,
  "kid": keyId
}

payload = {
  "iss": teamId,
  "exp": int(time_expired.strftime("%s")),
  "iat": int(time_now.strftime("%s"))
}


if __name__ == "__main__":
  """Create an auth token"""
  token = jwt.encode(payload, secret, algorithm=alg, headers=headers)

  print "----TOKEN----"
  print token

  print "----CURL----"
  print "curl -v -H 'Authorization: Bearer %s' \"https://api.music.apple.com/v1/catalog/us/artists/36954\" " % (token)
