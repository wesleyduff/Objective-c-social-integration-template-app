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
