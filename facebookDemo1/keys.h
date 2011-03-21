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
#define FacebookAppID @"149013028496185"
#define FacebookAPIKey @"cc962699775b1070a99e2d533b68ed59"
#define FacebookAppSecret @"cea276f908007642518fee461457b3be"
#define FacebookContactEmail @"slysop@gmail.com"
#define FacebookSupportEmail @"slysop@gmail.com"

/**
 * Twitter API KEYS AND SECRETS
 */
#define twitterConsumerkey @"KvtyfXXknfQioxnuq8nWg"
#define twitterConsumerSecret @"rMVX4emJI3cnVABH69HwJ1aR6WtdvzMhBNtx4WePzVE"
#define twitterRequestTokenURL @"http://twitter.com/oauth/request_token"
#define twitterAccessTokenURL @"http://twitter.com/oauth/access_token"
#define twitterAuthorizeURL @"http://twitter.com/oauth/authorize"
#define twitterAppProviderName @"wesduff.com"
#define twitterAppPrefix @"socialnetwork-integration"
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

#define kGowallaAPIKey			@"de5c34980c0e468bb237341c9eab3fd1"
#define kGowallaAPISecret		@"de73d3b5261944299b71e9c1641c3183"

// In order to intercept and respond to the OAuth callback, we need to register
// a custom URL type for the application. This should be unique, to avoid any
// naming collisions with other applications.
//
// Replace this in Info.plist with the callback for your application,
#define kGowallaRedirectURI		@"wessocialdev://"

// Keys for storing OAuth tokens using NSUserDefaults
#define kGowallaBasicOAuthAccessTokenPreferenceKey		@"gowalla_basic_oauth_access_token"
#define kGowallaBasicOAuthRefreshTokenPreferenceKey		@"gowalla_basic_oauth_refresh_token"
#define kGowallaBasicOAuthTokenExpirationPreferenceKey	@"gowalla_basic_oauth_token_expiration_date"