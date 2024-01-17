from firebase_admin import credentials, initialize_app, messaging

service_account_path = 'notif-pusher-poc-firebase-adminsdk-qscd8-4becadb760.json'

cred = credentials.Certificate(service_account_path)
firebase_app = initialize_app(cred)

# fake token
token = 'default'
topic = 'test1'

message = messaging.Message(
    notification=messaging.Notification(
        title='Your Message Title',
        body='Your message content.'
    ),
    topic='bipbop'
)

response = messaging.send(message, app=firebase_app)
print('Successfully sent message:', response)

# response = messaging.subscribe_to_topic(token, topic, app=firebase_app)
# errors = response.errors

# print('Result:', response.success_count, 'Successes and', response.failure_count, 'Failures')

# if errors:
#     for error in errors:
#         print(f"Error Index: {error.index} Reason: {error.reason}")

