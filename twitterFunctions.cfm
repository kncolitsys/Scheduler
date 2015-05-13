<cfclient>
	<cfscript>
		public any function searchTwitter(term,tweetCount){
			var twitterUtilities = new cfc.TwitterUtilities();
			twitterUtilities.getBearerToken (
				"NASio3HtxlLuASuwzVC7w",
				"Q3m4ogbSIzBHIetKeO4EgoD1aqtTE3KaXFsmqd1sow",
				function(){});
				
			twitterUtilities.setBearerToken("AAAAAAAAAAAAAAAAAAAAAEXNSwAAAAAAbVXTbvjn0TrKs8vddsv%2BiMblUUg%3D0nRh9JY6zTBa2jwi6kalLEDykJT7HjWDRezOlyvGuU");
			twitterUtilities.searchTweets(term, tweetCount, app.displayTweets);
		}
	</cfscript>
</cfclient>