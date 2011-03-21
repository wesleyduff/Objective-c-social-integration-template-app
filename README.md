# Mobile Application Development Social Integration Template
### This is the code to get you up and running quickly with Facebook, Gowalla, and Twitter

More to come at a later date

As of 3-21-2011 After changing the file "keys.h" with the appropriate api keys, app keys, etc.. you will be able to leverage facebook, twitter and gowalla's api.

As of 3-21-2011 The mobile platform iOS is the only mobile platform supported

Platforms currently being added

*	Android 2.1 +
*	Windows Phone 7
*	BlackBerry (to come in a much later date) 

## Instruction on getting up and running in less than a minute.

Download files

	git@github.com:slysop/Objective-c-social-integration-template-app.git

Open key.h and edit these lines

	//
	//  keys.h
	//  facebookDemo1
	//
	//  Created by Wes Duff on 3/17/11.
	//  Copyright 2011 __MyCompanyName__. All rights reserved.
	//


	/**
	 * FACEBOOK API KEYS AND SECRETS
	*/
	#define FacebookAppID @"<add yours>"
	#define FacebookAPIKey @"<add yours>"
	#define FacebookAppSecret @"<add yours>"
	#define FacebookContactEmail @"<add yours>"
	#define FacebookSupportEmail @"<add yours>"

	/**
	 * Twitter API KEYS AND SECRETS
	 */
	#define twitterConsumerkey @"<add yours>"
	#define twitterConsumerSecret @"<add yours>"
	#define twitterRequestTokenURL @"http://twitter.com/oauth/request_token"
	#define twitterAccessTokenURL @"http://twitter.com/oauth/access_token"
	#define twitterAuthorizeURL @"http://twitter.com/oauth/authorize"
	#define twitterAppProviderName @"<add yours>"
	#define twitterAppPrefix @"<add yours>"
	/*
	 We support hmac-sha1 signatures. We do not support the plaintext signature method. 
	 */


	/**
	 * GOWALLA API KEYS AND SECRETS
	 */
	#define kGowallaAPIBaseURL		@"https://api.gowalla.com/"
	#define kGowallaOAuthURL		@"https://gowalla.com/api/oauth/new"

	// Credentials for authentication using OAuth
	// Replace with your own credentials, available at http://api.gowalla.com/api/keys

	#define kGowallaAPIKey			@"<add yours>"
	#define kGowallaAPISecret		@"<add yours>"

	// In order to intercept and respond to the OAuth callback, we need to register
	// a custom URL type for the application. This should be unique, to avoid any
	// naming collisions with other applications.
	//
	// Replace this in Info.plist with the callback for your application,
	#define kGowallaRedirectURI		@"<add yours>"

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
				etc..
NOTE: do not add the "<" or ">" that is just the place where you add your appId.

Save and build. 

After you sign into facebook and accept the permissions then you should be directed back to the application.

Right now the application has four buttons. The first one grabs the user info and displays it in the Log aka the NSLog(); function

The second button when selected opens a dialog to post a message on your facebook page.

The third button opens a UIWebView that shows the login procedure for gowalla. Once signed in you can allow the application to function or deny. Once you choose the UIWebView goes away and the buttons are displayed once again.

The fourth button has the functionality to log you into your twitter account. It contains a UIWebView as well to manage the "Allow this application" functionality to take place.

Updates will be made almost every day so check back and pick it up when finished unless you want to play around with the code your self.

# HAPPY CODING!