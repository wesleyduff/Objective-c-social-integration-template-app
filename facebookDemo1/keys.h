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