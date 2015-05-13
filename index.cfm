<cfinclude template="/CFIDE/cfclient/useragent.cfm">

<cfclientsettings enabledeviceapi="true"/>
<cfclientsettings detectdevice="true" />

<!DOCTYPE html>
<html lang="en-US">

	<head>
		<title>Conference Schedule</title>
    	<meta http-equiv="x-ua-compatible" content="IE=edge" />
        <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-touch-fullscreen" content="yes">
    	<link href="assets/css/app.css" rel="stylesheet" media="screen">
	</head>
	
	<body class="snapjs-left">
		<!-- ColdFusion Functionality -->
		<!---<cfclient>--->
			<cfinclude template="DAOFunctions.cfm" >
			<cfinclude template="dataSynchFunctions.cfm" >
			<cfinclude template="twitterFunctions.cfm" >
			<cfinclude template="utilityFunctions.cfm" >	
			<cfinclude template="templates.cfm" >
		<!---</cfclient>--->
		
		<cfclient>
			<cfscript>
				//wipeDatabase();
				
				//call the includeJSCSSFiles function first to include the necessary JS files which are needed for the functions below
				//call needs to be synchronus so that there is enough time for everything to make it to the device before init is called
				//adding the init to the callback function guarantees that the files are displayed before teh methods are called
				invokeCFClientFunction('includeJSCSSFiles',null,function(){
					app.init();
					$('.headerWrapper').show();
					$('##sidebar').show();
				});
				
				//get connection type and setup event handlers for loss of connection
				//if testing in the browser you can't call getType so manually set the value
				//var connectionType = cfclient.connection.getType();
				var connectionType = 'WIFI';
				
				//get Application settings that are stored on the device and pass through to the dataSynch object, which handles all data communications with remote sources.
				invokeCFClientFunction('getApplicationSettings', function(appSettings){
					dataSynch.init(appSettings.updateURL,appSettings.saveURL,appSettings.dataUpdateFrequency,connectionType);	
				});	
				
				/* callback handlers */
				
				/*Update connection info in dataSynch object so data is not pulled/pushed when offline */
				cfclient.connection.onOnline(dataSynch.online);
				cfclient.connection.onOffline(dataSynch.offline);
				
				/*Stop the datasynch timer when battery level is low as polling can drain batter power*/
				cfclient.events.onBatteryCritical(dataSynch.stopTimer);
				
				/*Start datasynch timer when battery level is above 10%*/
				cfclient.events.onBatteryStatusChange(function(data){
					if(!dataSynch.isRunning && parseInt(data.level) > 10){
						dataSynch.startTimer();
					}
				});
				
				/* specify necessary css and js files based on device dimentions */
				cfclient.addResizeListener(includeJSCSSFiles);
			</cfscript>	
		</cfclient>	
		
		<div class="snap-drawers">
	        <div class="snap-drawer snap-drawer-left">
	            <div id="sidebar" class="page-sidebar" style="display:none;">
			        <div class="page-sidebar-scroll">
			            
			            <div class="sidebar-breadcrumb">NAVIGATION</div>
			                
			            <div class="navigation-item">
			                <a href="#/home" class="nav-item home-icon">Homepage<em class="unselected-item"></em></a>
			            </div>
			            
			             <div class="sidebar-decoration"></div>
			             
			            <div class="navigation-item">
			                <a href="#/myschedule" class="nav-item home-icon">My Schedule<em class="unselected-item"></em></a>
			            </div>
			                
			            <div class="sidebar-decoration"></div>
			            
			             <div class="navigation-item">
			                <a href="#/schedule" class="nav-item home-icon">Schedule<em class="unselected-item"></em></a>
			            </div>
			                
			            <div class="sidebar-decoration"></div>
			            
			            <div class="navigation-item">
			                <a href="#/sessions" class="nav-item ">Sessions<em class="unselected-item"></em></a>
			            </div>
			                
			            <div class="sidebar-decoration"></div>
			            
			            <div class="navigation-item">
			                <a href="#/speakers" class="nav-item home-icon">Speakers<em class="unselected-item"></em></a>
			            </div>
			                
			            <div class="sidebar-decoration"></div>
			            
			            <div class="navigation-item">
			                <a href="#/twitterFeed" class="nav-item home-icon">Twitter<em class="unselected-item"></em></a>
			            </div>
			                
			            <div class="sidebar-decoration"></div>
			            
			            <div class="navigation-item">
			                <a href="#/about" class="nav-item home-icon">About<em class="unselected-item"></em></a>
			            </div>
			            
			            <div class="sidebar-decoration"></div>
			            
			            <div class="navigation-item">
			                <a href="#/settings" class="nav-item home-icon">Settings<em class="unselected-item"></em></a>
			            </div>
			            
			            <div class="sidebar-decoration"></div>
			        </div>         
			    </div>
	        </div>
	        <div class="snap-drawer snap-drawer-right"></div>
	    </div>
	    
		<div id="content" class="page-content snap-content" >
			<div id="waiting" style="display:none"><span class="spacer"></span><img src="assets/images/139468063733.gif" /></div>
			<div class="headerOuterWrapper">
				<div class="headerWrapper" style="display:none;">
					<a href="#/notifications" class="notificationButton" style="display:none">
						<div class="notificationCounter"></div>
					</a>
					<a class="mainMenuButton deploy-sidebar" id="navigationBtn" style="display:none"></a>
					<h1>Conference 2014</h1>
				</div>
			</div>
			<div class="pageWrapper">
				<div class="pageContentWrapper">
	
					<div id="loginPage" style="display:none" class="subpage navpage">
						<h1>Login</h1>
						<p>To use this application, you need to have an account.</p>
						<p>Login with your account credentials below. If you do not have an account please create one on the conference web site</p>
						
						<p id="loginStatus" style="display:none"></p>
						<table width="100%" style="margin-left:auto; margin-right:auto;">
							<tr>
								<td>Username:</td>
								<td><input type="text" id="username" /></td>
							</tr>
							<tr>
								<td>Password:</td>
								<td><input type="password" id="password" /></td>
							</tr>	
							<tr>
								<td colspan="2" align="center">
									<a class="no-bottom demo-button button-minimal gblue-minimal" href="#" id="loginSubmit">Login</a>
							</tr>
						</table>	
					</div>
					<div id="homePage" style="display:none" class="navpage" >
						<div id="homepageContainer">
							
							<div id="homepage">
								<a href="#/myschedule">
									<span class="icon-MySchedule"></span>
									<br clear="all" />
									My Schedule
								</a> 
								
								<a href="#/schedule">
									<span class="icon-Schedule"></span>
									<br clear="all" />
									Schedule
								</a> 
								
								<a href="#/speakers">
									<span class="icon-Speakers"></span>
									<br clear="all" />
									Speakers
								</a>
								
								<a href="#/sessions">
									<span class="icon-Sessions"></span>
									<br clear="all" />
									Sessions
								</a> 
								
								<a href="#/twitterFeed">
									<span class="icon-Twitter"></span>
									<br clear="all" />
									Twitter
								</a>
								
								<a href="#/settings">
									<span class="icon-Settings"></span>
									<br clear="all" />
									Settings
								</a>
							</div>	
							
							<br clear="all" />	
						 </div> 
					</div>	
					<div id="sessionsPage" style="display:none" class="subpage navpage"></div>
					<div id="sessionPage" style="display:none" class="subpage navpage"></div>
					<div id="surveyPage" style="display:none" class="subpage navpage"></div>
					<div id="speakersPage" style="display:none" class="subpage navpage"></div>
					<div id="speakerPage" style="display:none" class="subpage navpage"></div>
					<div id="schedulePage" style="display:none" class="navpage"></div>
					<div id="mySchedulePage" style="display:none" class="navpage"></div>
					<div id="notificationPage" style="display:none" class="navpage"></div>
					<div id="twitterPage" style="display:none" class="navpage"></div>
					<div id="aboutPage" style="display:none" class="subpage navpage"></div>
					<div id="settingsPage" style="display:none" class="subpage navpage"></div>
				</div>
			</div>	
		</div>	
		
		<div id="rightPanel">
			<a id="rightPanelClose"> </a>
			<div id="rightPanelContent"></div>
		</div>	
	
	</body>
		
	
		
	<!-- libraries -->
	<script src="assets/js/jquery.min.js"></script>
	<script src="assets/js/mustache.js"></script>
	<script src="assets/js/director.js"></script>
	<script src="assets/js/snap.js"></script>
	
	<!-- app files -->
	<script src="assets/js/app.js"></script>
	<script src="assets/js/dataSynch.js"></script>
	<script src="assets/js/routes.js"></script>
	<script src="assets/js/CodeBird.js"></script>
	<script src="assets/js/sha1.js"></script>

	<script>
	var router = Router(routes);
		router.init();
	</script>	
    
</html>