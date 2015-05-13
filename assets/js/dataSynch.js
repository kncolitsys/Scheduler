var dataSynch = {
	isOnline: false,
	isRunning:false,
	updateURL:'',
	saveURL:'',
	updatesTimer:'',
	dataUpdateFrequency:'',
	init: function(_updateURL,_saveURL,_dataUpdateFrequency,_connectionType){
		
		dataSynch.updateURL=_updateURL;
		dataSynch.saveURL=_saveURL;
		
		if(_connectionType == 'NONE'){
			dataSynch.offline();
		}else{
			dataSynch.online();
		}
		
		dataSynch.checkDatabaseExists();
		dataSynch.checkForDataUpdates();
		app.checkNotifications();
		
		dataSynch.startTimer(_dataUpdateFrequency);
	},
	online: function(){
		dataSynch.isOnline=true;
	},
	offline: function(){
		dataSynch.isOnline=false;
	},
	startTimer: function(minutes){

		if(typeof minutes == 'undefined'){
			minutes = dataSynch.dataUpdateFrequency;
		}

		dataSynch.updatesTimer = setInterval(function(){dataSynch.checkForDataUpdates()},(minutes *1000));
		dataSynch.isRunning=true;
		dataSynch.dataUpdateFrequency = minutes;
	},
	stopTimer: function(){
		clearInterval(dataSynch.updatesTimer);
		dataSynch.isRunning=false;
	},
	checkDatabaseExists: function(){
		invokeCFClientFunction('checkIfDatabaseExists', function(data) {
			if(!data){
				dataSynch.createDatabase();
			}
		});	
	},
	createDatabase: function(){
		invokeCFClientFunction('generateDatabase', function() {
			dataSynch.checkForDataUpdates();
		});
	},
	checkForDataUpdates: function(){
		if(dataSynch.isOnline){
			invokeCFClientFunction('getLastUpdateDate', function(dateLastUpdated) {
				$.ajax({
				  type: 'GET',
				  url: dataSynch.updateURL,
				  data: { userID: app.getUserID(), LASTUPDATEDDATETIME: dateLastUpdated },
				  dataType: 'json',
				  success: function(data){
				  	for(table in data){
				  		for(row in data[table]){
				  			invokeCFClientFunction('saveData',table,data[table][row],null);
				  		}
				  	}
				  	
				  	invokeCFClientFunction('setLastUpdateDate');
				  },
				  error: function(xhr, type){
				    console.log(type);
				    console.log(xhr);
				  }
				});
			});
			
			//pause to let data be parsed before updating notifications
			setTimeout(app.checkNotifications,'3000');
		}	
	},
	pushUpdates: function(){
		if(isOnline){
			invokeCFClientFunction('getUnsynchedData', function(unsynchedData) {
					$.ajax({
					  type: 'POST',
					  url: dataSynch.saveURL,
					  data: { userID: app.getUserID(), data:unsynchedData},
					  dataType: 'json',
					  success: function(){
					  	invokeCFClientFunction('updateSynchData');
					  },
					  error: function(xhr, type){
					    console.log(type);
					    console.log(xhr);
					  }
					});
				});
		}	
	},
	resetDatabase: function(){
		invokeCFClientFunction('wipeDatabase');
	}
}