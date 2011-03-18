# Mobile Application Development Social Integration Template
### This is the code to get you up and running quickly with Facebook, Gowalla, and Twitter

More to come at a later date

As of 3-18-2011 After changing the file "keys.h" with the appropriate api keys, app keys, etc.. you will be able to leverage facebook and gowalla's api.
NOTE: Twitter api integration should be completed and available for use on 3-21-2011. Thanks

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
	#define kGowallaAPIBaseURL		@"https://api.gowalla.com/"
	#define kGowallaOAuthURL		@"https://gowalla.com/api/oauth/new"

	// Credentials for authentication using OAuth
	// Replace with your own credentials, available at http://api.gowalla.com/api/keys

	#define kGowallaAPIKey			@"<add your app id>"
	#define kGowallaAPISecret		@"<add your app secret>"

	// In order to intercept and respond to the OAuth callback, we need to register
	// a custom URL type for the application. This should be unique, to avoid any
	// naming collisions with other applications.
	//
	// Replace this in Info.plist with the callback for your application,
	#define kGowallaRedirectURI		@"<your callback url : should be something like whatever://> "

	// Keys for storing OAuth tokens using NSUserDefaults
	#define kGowallaBasicOAuthAccessTokenPreferenceKey		@"gowalla_basic_oauth_access_token"
	#define kGowallaBasicOAuthRefreshTokenPreferenceKey		@"gowalla_basic_oauth_refresh_token"
	#define kGowallaBasicOAuthTokenExpirationPreferenceKey	@"gowalla_basic_oauth_token_expiration_date"

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