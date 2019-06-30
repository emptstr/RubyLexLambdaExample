# require 'httparty'
require 'json'

def lambda_handler(event:, context:)
  {
    'dialogAction': {
    'type': 'Close',
    'fulfillmentState': 'Fulfilled',
    'message': {
     'contentType': 'PlainText',
     'content': 'Hello World!'
    }
   }
 }
end
