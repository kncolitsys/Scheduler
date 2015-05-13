<cfclient>
	<cfscript>
		public boolean function checkLogin(){
			var response={success:false,userID:''};
			
			try{
				var userID = cfclient.localstorage.getItem('userID');
				if(len(trim(userID ))){
					response.success=true;
					response.userID = userID;
					return response;
				}else{
					return response;
				}
			}catch (any e){
				return response;
			}
		}
		
		public void function setLoginCredentials(credentials){
			cfclient.localstorage.setItem('userID',credentials);
		}
		
		public struct function getApplicationSettings(){
			var result={twitterCount:50,dataUpdateFrequency:15,updateURL='',saveURL='',twitterTerm='cfobjective'};
			
			try{
				result.twitterTerm = cfclient.localstorage.getItem('twitterTerm');
				
				if(isNull(result.twitterTerm)){
					cfclient.localstorage.setItem('twitterTerm','cfobjective');
					result.twitterTerm='cfobjective';
				}
			}catch (any e){
				cfclient.localstorage.setItem('twitterTerm','cfobjective');
			}
			
			try{
				result.updateURL = cfclient.localstorage.getItem('updateURL');
				
				if(isNull(result.updateURL)){
					cfclient.localstorage.setItem('updateURL','http://app.simonfree.com/data.cfc?method=getUpdatedData');
					result.updateURL='http://app.simonfree.com/data.cfc?method=getUpdatedData';
				}
			}catch (any e){
				cfclient.localstorage.setItem('updateURL','http://app.simonfree.com/data.cfc?method=getUpdatedData');
			}
			
			try{
				result.saveURL = cfclient.localstorage.getItem('saveURL');
				
				if(isNull(result.saveURL)){
					cfclient.localstorage.setItem('saveURL','http://app.simonfree.com/data.cfc?method=updateData');
					result.saveURL='http://app.simonfree.com/data.cfc?method=updateData';
				}
			}catch (any e){
				cfclient.localstorage.setItem('saveURL','http://app.simonfree.com/data.cfc?method=updateData');
			}
			
			try{
				result.twitterCount = cfclient.localstorage.getItem('twitterCount');
				
				if(isNull(result.twitterCount)){
					cfclient.localstorage.setItem('twitterCount',50);
					result.twitterCount=50;
				}

			}catch (any e){
				cfclient.localstorage.setItem('twitterCount',50);
			}

			try{
				result.dataUpdateFrequency = cfclient.localstorage.getItem('dataUpdateFrequency');
				
				if(isNull(result.dataUpdateFrequency)){
					cfclient.localstorage.setItem('dataUpdateFrequency',15);
					result.dataUpdateFrequency=15;
				}
			}catch (any e){
				cfclient.localstorage.setItem('dataUpdateFrequency',15);
			}

			return result;
		}
		
		public boolean function saveApplicationSettings(data){
			cfclient.localstorage.setItem('dataUpdateFrequency',data.dataUpdateFrequency);
			cfclient.localstorage.setItem('twitterCount',data.twitterCount);
			cfclient.localstorage.setItem('updateURL',data.updateURL);
			cfclient.localstorage.setItem('saveURL',data.saveURL);
			
			dataSynch.stopTimer();
			dataSynch.startTimer(data.dataUpdateFrequency);

			return true;
		}
		
		public void function dispatchNotificationVibration(){
			cfclient.notification.vibrate(1000);
		}
		
		public void function includeJSCSSFiles(){
					
			if(cfclient.properties.width lte 480){
				include "assets/css/app-mobile.css";
				include "assets/js/app-mobile.js";
			}else{
				include "assets/css/app-tablet.css";
				include "assets/js/app-tablet.js";
			}
		}
	</cfscript>
</cfclient>	