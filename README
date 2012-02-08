ASI-OAuth
---------

This is implementation of OAuth 1.0 signing + authorization flow, built on top of ASI-HTTP-Request. 

This set of classes depends on:
- https://github.com/keybuk/asi-http-request-oauth
- https://github.com/pokeb/asi-http-request

Usage on dropbox example:

	ASIOAuthClient* oauthClient = [[ASIOAuthClient alloc] init];

	// setup api keys
	oauthClient.consumerKey = YOUR_CONSUMER_KEY;
	oauthClient.consumerSecret = YOUR_CONSUMER_SECRET;

	// configure routes
	oauthClient.oauthRequestTokenURL = @"https://api.dropbox.com/1/oauth/request_token";
	oauthClient.oauthAuthorizeURL = @"https://www.dropbox.com/1/oauth/authorize";
	oauthClient.oauthAccessTokenURL = @"https://api.dropbox.com/1/oauth/access_token";

	[oauthClient startAuthorization];

