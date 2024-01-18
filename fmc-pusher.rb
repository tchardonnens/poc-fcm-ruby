require 'httparty'
require 'json'
require 'googleauth'
require 'dotenv'

Dotenv.load

auth_file = ENV['GOOGLE_APPLICATION_CREDENTIALS']
project_id = ENV['PROJECT_ID']
scope = 'https://www.googleapis.com/auth/firebase.messaging'

authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: File.open(auth_file),
  scope: scope
)

authorizer.fetch_access_token!

def send_push_notification(access_token, project_id, title, body)
  url = "https://fcm.googleapis.com/v1/projects/#{project_id}/messages:send"
  headers = {
    'Content-Type' => 'application/json',
    'Authorization' => 'Bearer ' + access_token
  }
  body = {
    "validate_only": true,
    "message": {
        "notification": {
            "title": "Migrate notification system",
            "body": "Hello Qonto"
        },
        "android": {
			"notification": {
				"click_action": "test",
			},
        },
        "apns": {
			"payload": {
				"aps": {
					"category": "test"
				}
			},
        },
        # replace by registration token instead of topic
        # "token": "registration_token"
        "topic": "test"
    }
  }.to_json

  response = HTTParty.post(url, headers: headers, body: body)
  puts response.body
end

# Replace 'YOUR_DEVICE_TOKEN' with an actual device token
send_push_notification(authorizer.access_token, project_id, 'Hello Qonto!', 'Update notification system')
