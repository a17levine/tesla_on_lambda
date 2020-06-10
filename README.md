# Tesla on Lambda

This [Jets](https://rubyonjets.com/) project allows you to create public endpoints for your Tesla vehicle powered by AWS Lambda. This allows you to use Siri to command your vehicle to turn on the HVAC by saying "hey Siri, start my car". 

Lambda has such a generous 'free tier' that you will not likely see any charges on your AWS bill, so it's free! Lambda functions are kept alive by the Jets framework to avoid cold starts.


## How it works

There are two controller actions in this project. One turns on your HVAC and the other turns it off (if you change your mind or made a mistake). When deployed, you'll get a public URL so any request will invoke the function. It's not secure but I didn't feel the need to secure it. You could add a long secret key if you're paranoid.

Once invoked, the controller action returns a 200 OK but then enqueues the work to be done by the 'tesla_hvac_job' which actually performs the work within 10-20 seconds typically.

Problems can occur and Amazon's logging system CloudWatch is hard to work with so I integrated Slack to do output for the program. That way you can know what goes wrong and you can have that notification hit your mobile via a notification.

This is a generic "Jets" app which is basically Ruby on Rails designed to work within the Amazon AWS Lambda environment. If you have errors, consult the forums or the Jets documentation.

## Getting started


## IAM User Permissions for deploy

You need to enable your IAM user for these permissions to be able to deploy

AWSLambdaFullAccess
IAMFullAccess
AmazonAPIGatewayInvokeFullAccess
AmazonAPIGatewayAdministrator
AWSCloudFormationFullAccess

