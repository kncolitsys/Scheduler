<script id="sessionsTmpl" type="text/template">
	{{#sessions}}		
	<div class="listItem">
		<a href="#/session/view/{{sessionid}}"><img src='{{headshot}}' border="0"/></a>
		<h4><a href="#/session/view/{{sessionid}}">{{title}}</a></h4>
		{{speaker}}	
	</div>
	<div class="textBreakBoth"></div>
	{{/sessions}}
</script>

<script id="speakersTmpl" type="text/template">
	{{#speakers}}		
	<div class="listItem">
		<a href="#/speaker/view/{{speakerid}}"><img src='{{headshot}}' border="0"/></a><br />
		
		<h4><a href="#/speaker/view/{{speakerid}}">{{firstname}} {{lastname}}</a></h4>
		<p>{{company}}</p>
	</div>
	<div class="textBreakBoth"></div>
	{{/speakers}}
	
	<br clear="all" />
</script>

<script id="scheduleTmpl" type="text/template">
	<div class="navigationContainer">
		<nav class="nav">
			<ul class="nav-list">
				{{#schedule}}	
				<li>
					<a class="nav-link {{#active}}active{{/active}}" day="{{dayid}}">
					{{title}}
					</a>
				</li>
				{{/schedule}}	
			</ul>
			<br clear="all" />
		</nav>
	</div>
	
	{{#schedule}}	
		<div class="day" id="{{dayid}}" {{#active}}style="display:block"{{/active}}>
    		{{#timeslots}}
    			<div class="timeslot" >
	    			{{#global}}
	    				<div class="heading"><h1>{{title}}</h1></div>
	    			{{/global}}
	    			
	    			{{^global}}
		    			<div class="heading sessions"><h1>{{title}}</h1></div>
		    			<div class="sessions">
			    			{{#sessions}}
			    				<div class="session {{trackid}}">
			    					<a href="#/session/view/{{sessionID}}"><img src='{{headshot}}' border="0" /></a>
			    					<h3><a href="#/session/view/{{sessionID}}">{{name}}</a></h3>
			    					<a href="#/speaker/view/{{speakerID}}">{{speaker}}</a><br />
			    					{{track}}
			    				</div>	
			    				<div class="textBreakBoth"></div>
			    			{{/sessions}}
		    			</div>
	    			{{/global}}
    			</div>
    		{{/timeslots}}
		</div>
	{{/schedule}}
</script>

<script id="myScheduleTmpl" type="text/template">
	<div class="navigationContainer">
		<nav class="nav">
			<ul class="nav-list">
				{{#schedule}}	
				<li>
					<a class="nav-link-my-schedule {{#active}}active{{/active}}" day="{{dayid}}">
					{{title}}
					</a>
				</li>
				{{/schedule}}	
			</ul>
			<br clear="all" />
		</nav>
	</div>
	
	{{#schedule}}	
		<div class="day" id="mySchedule{{dayid}}" {{#active}}style="display:block"{{/active}}>
    		{{#timeslots}}
    			<div class="timeslot" >
	    			{{#global}}
	    				<div class="heading"><h1>{{title}}</h1></div>
	    			{{/global}}
	    			
	    			{{^global}}
		    			<div class="heading sessions"><h1>{{title}}</h1></div>
		    			<div class="sessions">
			    			{{#sessions}}
			    				<div class="session {{trackid}}">
			    					<a href="#/session/view/{{sessionID}}"><img src='{{headshot}}' border="0" /></a>
			    					<h3><a href="#/session/view/{{sessionID}}">{{name}}</a></h3>
			    					<a href="#/speaker/view/{{speakerID}}">{{speaker}}</a><br />
			    					{{track}}
			    				</div>	
			    				<div class="textBreakBoth"></div>
			    			{{/sessions}}
		    			</div>
	    			{{/global}}
    			</div>
    		{{/timeslots}}
		</div>
	{{/schedule}}
</script>

<script id="notificationsTmpl" type="text/template">
	{{#notifications}}		
	<div class="notificationItem">
		<div class="heading">
			{{createddate}}
			<div class="expand"><img src="assets/images/arrow-down.png"/></div>
		</div>	
		<div class="notificationSummary">
		{{subject}}
		</div>
		<div class="notificationBody">
			{{notification}}
		</div>	
	</div>
	{{/notifications}}
</script>

<script id="sessionTmpl" type="text/template">
	<img src="{{headshot}}" />
	<h2>{{title}}</h2>
	<h4><a href="#/speaker/view/{{speakerid}}">{{firstname}} {{lastname}}</a></h4>
	<p>Track: {{track}}</p>
	<br clear="all" />
	<p>
		<a class="no-bottom demo-button button-minimal green-minimal removeFromSchedule" sessionID="{{sessionid}}" {{^inSchedule}}style="display:none"{{/inSchedule}}>Remove From Schedule</a>
		<a class="no-bottom demo-button button-minimal green-minimal addToSchedule" sessionID="{{sessionid}}" {{#inSchedule}}style="display:none"{{/inSchedule}}>Add to my Schedule</a>
		<a class="no-bottom demo-button button-minimal green-minimal" href="#/survey/{{sessionid}}" >Survey </a>
	</p>
	
	<p>{{description}}</p>	
</script>

<script id="speakerTmpl" type="text/template">
	<img src="{{headshot}}" />
	<h2>{{firstname}} {{lastname}}</h2>
	<h4>{{company}}</h4>
	<h4>{{title}}</h4>
	<br clear="all" />
	{{bio}}
	<br clear="all" />
	<br clear="all" />
	<h2>
		Sessions
	</h2>	
	<ul>
		{{#sessions}}
		<li><a href="#/session/view/{{sessionid}}">{{title}}</a></li>
		{{/sessions}}
	</ul>	
</script>

<script id="twitterTmpl" type="text/template">
	
	{{#tweets}}
		<div class="tweet">
			<img src="{{user.profile_image_url}}" />
			<p class="screenname">@{{user.screen_name}}</p>
			<p class="created">{{created}}</p>
			<br clear="all" />
			<p class="message">{{message}}</p>
		</div>	
	{{/tweets}}
	
</script>

<script id="aboutTmpl" type="text/template">
	
	<p>This application is a sample application that demonstrates the many features of ColdFusion 11 and the new Mobile features.</p>
	<p>
		Libraries used in this application include:
		<ul>
			<li>mustachejs</li>
			<li>directorjs</li>
			<li>snapjs</li>
		</ul>
	</p>		
	<p>The data was last updated on {{lastUpdatedDate}}</p>
	<p align="center"><a class="no-bottom demo-button button-minimal yellow-minimal" href="#" id="synchDataButton">Synch Data Now</a></p>
	
</script>

<script id="settingsTmpl" type="text/template">
	<div class="small-notification green-notification" id="settingsNotification" style="display:none;">
		<p>Settings saved successfully!</p>
	</div>
	<table width="100%">
		<tr>
			<td>
				Data Update Interval (minutes):
			</td>
			<td>
				<input type="text" id="dataUpdateFrequency" value="{{dataUpdateFrequency}}" />
			</td>
		</tr>
		<tr>
			<td>
				Tweets to display:
			</td>
			<td>
				<input type="text" id="twitterCount" value="{{twitterCount}}" />
			</td>
		</tr>
				
		<tr>
			<td>
				Update URL:
			</td>
			<td>
				<input type="text" id="updateURL" value="{{updateURL}}" />
			</td>
		</tr>	
		
		<tr>
			<td>
				Save URL:
			</td>
			<td>
				<input type="text" id="saveURL" value="{{saveURL}}" />
			</td>
		</tr>			
	</table>	
	<p align="center"><a class="no-bottom demo-button button-minimal green-minimal" href="#" id="saveSettingsButton">Save</a></p>
	<p align="center"><a class="no-bottom demo-button button-minimal red-minimal" href="#" id="clearDatabaseButton">Clear Database</a></p>
	
</script>

<script id="surveyTmpl" type="text/template">
	<input type="hidden" id="sessionID" value="{{sessionid}}" />
	<input type="hidden" id="surveyID" value="{{surveyid}}" />
	<h3>{{title}}</h3> 
	<h2>by {{firstname}} {{lastname}}</h2>
	<br />
	<div class="column">
		<p>
			Q1: How would you rate the session?
		</p>	
		<p class="center-text">
			<a class="checker q1" href="#">1</a>
			<a class="checker q1" href="#">2</a>
			<a class="checker q1" href="#">3</a>
			<a class="checker q1" href="#">4</a>
			<a class="checker q1" href="#">5</a>
		</p>
		
		<p>
			Q2: How would you rate the speaker?
		</p>	
		<p class="center-text">
			<a class="checker q2" href="#">1</a>
			<a class="checker q2" href="#">2</a>
			<a class="checker q2" href="#">3</a>
			<a class="checker q2" href="#">4</a>
			<a class="checker q2" href="#">5</a>
		</p>
		
		<p>
			Q3: How likely are you to recommend this session to others?
		</p>	
		<p class="center-text">
			<a class="checker q3" href="#">1</a>
			<a class="checker q3" href="#">2</a>
			<a class="checker q3" href="#">3</a>
			<a class="checker q3" href="#">4</a>
			<a class="checker q3" href="#">5</a>
		</p>
		
		<p>
			Q4: How would you rate the room?
		</p>	
		<p class="center-text">
			<a class="checker q4" href="#">1</a>
			<a class="checker q4" href="#">2</a>
			<a class="checker q4" href="#">3</a>
			<a class="checker q4" href="#">4</a>
			<a class="checker q4" href="#">5</a>
		</p>
		
		<p>
			Q5: How would you rate the handouts?
		</p>	
		<p class="center-text">
			<a class="checker q5" href="#">1</a>
			<a class="checker q5" href="#">2</a>
			<a class="checker q5" href="#">3</a>
			<a class="checker q5" href="#">4</a>
			<a class="checker q5" href="#">5</a>
		</p>

		<p>
			Additional Comments:<br />
			<textarea id="notes" class="contactTextarea">{{notes}}</textarea>
		</p>
		
		<p class="center-text">
			<a class="no-bottom demo-button button-minimal green-minimal" href="#" id="saveSurveysButton">Save</a>
		</p>
	</div>	
</script>