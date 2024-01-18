require 'httparty'
require 'json'
require 'googleauth'
require 'dotenv'

Dotenv.load

auth_file = ENV['GOOGLE_APPLICATION_CREDENTIALS']
project_id = ENV['PROJECT_ID']
registration_token = ENV['REGISTRATION_KEY']
scope = 'https://www.googleapis.com/auth/firebase.messaging'

authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: File.open(auth_file),
  scope: scope
)

authorizer.fetch_access_token!

def send_push_notification(access_token, project_id, registration_token, title, body)
  url = "https://fcm.googleapis.com/v1/projects/#{project_id}/messages:send"
  headers = {
    'Content-Type' => 'application/json',
    'Authorization' => 'Bearer ' + access_token
  }
  body = {
    "validate_only": false,
    "message": {
        "notification": {
            "title": "Migrate notification system",
            "body": "Hello Qonto with full payload"
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
        "token": registration_token,
    }
  }.to_json

  response = HTTParty.post(url, headers: headers, body: body)
  puts response.body
end

send_push_notification(authorizer.access_token, project_id, registration_token ,'Hello Qonto!', 'Update notification system')
