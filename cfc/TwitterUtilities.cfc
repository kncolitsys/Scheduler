component client="true"
{
	var cb = new Codebird();
	var bearerToken = "";
	
	function searchTweets (searchText, tweetCount, callbackFunc)
	{
		try
		{
			cb.setBearerToken(bearerToken);
			cb.__call(
	    		"search_tweets",
	    		"count=" + tweetCount + "&q=" + searchText,
	    		callbackFunc,
	    		true 
			); 
		} 
		catch (any e)
		{
			alert("Error : " + e);
		}
	}
	
	function setBearerToken (token)
	{
		bearerToken = token;
	}
	
	function getBearerToken (consumer_key, consumer_secret, callback_func)
	{
		cb.setConsumerKey(consumer_key,consumer_secret);
		
		cb.__call(
		   	"oauth2_token",
		   	{},
		   	callback_func
		);
	}
	
}