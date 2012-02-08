ASI-OAuth
---------

This is implementation of OAuth 1.0 signing + authorization flow, built on top of ASI-HTTP-Request. 

This set of classes depends on:

- https://github.com/keybuk/asi-http-request-oauth
- https://github.com/pokeb/asi-http-request

Basic usage:

	ASIOAuthClient* oauthClient = [[ASIOAuthClient alloc] init];

	// setup API keys
	oauthClient.consumer.consumerKey = YOUR_CONSUMER_KEY;
	oauthClient.consumer.consumerSecret = YOUR_CONSUMER_SECRET;

	// configure your oauth provider routes
	oauthClient.consumer.oauthRequestTokenURL = @"https://api.dropbox.com/1/oauth/request_token";
	oauthClient.consumer.oauthAuthorizeURL = @"https://www.dropbox.com/1/oauth/authorize";
	oauthClient.consumer.oauthAccessTokenURL = @"https://api.dropbox.com/1/oauth/access_token";
	
	// set your delegate, see ASIOAuthClientDelegate.h for details
	oauthClient.delegate = yourDelegate;
	
	// this starts authorization, e.g. pops up WebView overlay
	[oauthClient authorize];

It's possible to override WebView-based helper with your own implementation. Your class must comform to 
ASIOAuthWebHelperProtocol and use ASIOAuthWebHelperDelegate to return redirect requests to ASIOAuthConsumer, 
use the following code to replace default helper:

	oauthClient.consumer.authorizeHelper = yourHelper;
