require 'httparty'
require 'json'
require 'googleauth'

auth_file = './qonto-staging-3dbe20386224.json'
scope = 'https://www.googleapis.com/auth/firebase.messaging'

authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: File.open(auth_file),
  scope: scope
)

authorizer.fetch_access_token!

def send_push_notification(access_token, title, body)
  url = 'https://fcm.googleapis.com/v1/projects/1048218553805/messages:send'
  headers = {
    'Content-Type' => 'application/json',
    'Authorization' => 'Bearer ' + access_token
  }
  body = {
    "validate_only": false,
    "message": {
        "name": "projects/1048218553805/messages/1",
        "notification": {
            "title": "Migrate notification system",
            "body": "Hello Qonto"
        },
        "topic": "bipbop"
    }
    
  }.to_json

  response = HTTParty.post(url, headers: headers, body: body)
  puts response.body
end

# Replace 'YOUR_DEVICE_TOKEN' with an actual device token
send_push_notification(authorizer.access_token, 'Hello Qonto!', 'Update notification system')
