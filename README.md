# Tesla on Lambda

This [Jets](https://rubyonjets.com/) project allows you to create public endpoints for your Tesla vehicle powered by AWS Lambda. This allows you to use Siri to command your vehicle to turn on the HVAC by saying "hey Siri, start my car". 

Lambda has such a generous 'free tier' that you will not likely see any charges on your AWS bill, so it's free! Lambda functions are kept alive by the Jets framework to avoid cold starts.


## How it works

There are two controller actions in this project. One turns on your HVAC and the other turns it off (if you change your mind or made a mistake). When deployed, you'll get a public URL so any request will invoke the function. It's not secure but I didn't feel the need to secure it. You could add a long secret key if you're paranoid.

Once invoked, the controller action returns a 200 OK but then enqueues the work to be done by the 'tesla_hvac_job' which actually performs the work within 10-20 seconds typically.

Problems can occur and Amazon's logging system CloudWatch is hard to work with so I integrated Slack to do output for the program. That way you can know what goes wrong and you can have that notification hit your mobile via a notification.

This is a generic "Jets" app which is basically Ruby on Rails designed to work within the Amazon AWS Lambda environment. If you have errors, consult the forums or the Jets documentation.

## Getting started

1. Create an AWS account if you don't have one
2. Rename the file deploy.sh.example to deploy.sh
3. Read the instructions in that file to create a user in the [IAM console](https://console.aws.amazon.com/iam/home) with the appropriate permissions and copy the credentials into the file when you're done
4. Rename .env.example file to .env and follow the instructions to fill out your credentials
5. Install Ruby 2.5.8 and bundler `gem install bundler`, then `bundle install`
6. Load the local server and test to see if it works. `jets server` should load up on port 8888. Once launched, hit http://localhost:8888/tesla/start_hvac. The Tesla App should show that the HVAC is on.
7. Run `./deploy.sh` to deploy to AWS Lambda
8. When the deploy succeeds you'll see the base URL, looks like this: https://4jt24j2462lj.execute-api.us-east-1.amazonaws.com/.
9. Test invoking it buy loading this URL in the browswer: https://4jt24j2462lj.execute-api.us-east-1.amazonaws.com/dev/tesla/start_hvac. The Tesla App should show that the HVAC is on.
10. Open the Shortcuts app on iOS, you might have to download it from the app store. Make a shortcut called 'start my car'. Use the action 'get contents of' and paste in this web address for starting the hvac. You can also have it speak 'car started' by loading up the 'speak' action in 'documents'. Repeat all of this for stopping the HVAC as well.
11. Enjoy!


## IAM User Permissions for deploy

You need to enable your IAM user for these permissions to be able to deploy

AWSLambdaFullAccess
IAMFullAccess
AmazonAPIGatewayInvokeFullAccess
AmazonAPIGatewayAdministrator
AWSCloudFormationFullAccess

