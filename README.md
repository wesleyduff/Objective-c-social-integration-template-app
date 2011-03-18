# Mobile Application Development Social Integration Template
### This is the code to get you up and running quickly with Facebook, Gowalla, and Twitter

More to come at a later date

As of 3-17-2011 facebook is the only working social network for this template application.

As of 3-17-2011 The mobile plateform iOS is the only mobile platform supported

Platforms currently being added

*	Android 2.1 +
*	Windows Phone 7
*	BlackBerry (to come in a much later date) 

## Instruction on getting up and running in less than a minute.

Download files

	git@github.com:slysop/Objective-c-social-integration-template-app.git

Open key.h and edit these lines

	/**
	 * FACEBOOK API KEYS AND SECRETS
	*/
	#define FacebookAppID @"<add your app id>"
	#define FacebookAPIKey @"<add your api key>"
	#define FacebookAppSecret @"<add your app secret>"
	#define FacebookContactEmail @"<add your contact email>"
	#define FacebookSupportEmail @"<add your support email>"

	/**
	 * GOWALLA API KEYS AND SECRETS
	 */
	#define GowallaAPIKey @"<add your api key>"
	#define GowallaSecretKey @"<add your secret key>"
	#define GowallaApplicationWebsite @"<add your application website>"
	#define GowallaApplicationSupportWebsite @"<add your support website>"
	#define GowallaOAuthCallbackURL @"<add your oathcallback url>"

#### NOTE: Gowalla is under construction so you can just leave that section as is. Just update the Facebook api section with your data.

IMPORTANT : open the "Supporting Files" folder and double click the facebookDemo1-info.plist.
You will need to update the FB URL with your appID

#### NOTE: I am using the new XCODE 4. This may be different if you are using an older version

*	URL types
	*	item 0
		*	URL Schemes
			*	item 0	string fb\<add your appId\>
NOTE: do not add the "<" or ">" that is just the place where you add your appId.

Save and build. 

After you sign into facebook and accept the permissions then you should be directed back to the application.

Right now the application only has two buttons. The first one grabs the user info and displays it in the Log aka the NSLog(); function

The section button when selected opens a dialog to post a message on your facebook page.

Updates will be made almost every day so check back and pick it up when finished unless you want to play around with the code your self.

# HAPPY CODING!