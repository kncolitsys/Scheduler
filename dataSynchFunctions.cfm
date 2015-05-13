<cfclient>
	<cfscript>
		window.dsName = 'cfObjectiveScheduler';
		
		public boolean function checkIfDatabaseExists(){
			try{
				queryExecute("SELECT sessionID from session LIMIT 1",[],{"datasource":#window.dsName#});
				return true;
			}catch(any e){
				return false;
			}
		}
		
		public void function generateDatabase(){
			return invokeInSyncMode(createTables());
		}
		
		public void function saveData(table,rowData){
			switch(table){
				case 'notification':
					if(rowData.update){
						updateNotification(rowData);
					}else{
						saveNotification(rowData);
					}
				break;
				
				case 'day':
					if(rowData.update){
						updateDay(rowData);
					}else{
						saveDay(rowData);
					}
				break;
				
				case 'track':
					if(rowData.update){
						updateTrack(rowData);
					}else{
						saveTrack(rowData);
					}
				break;
				
				case 'speaker':
					if(rowData.update){
						updateSpeaker(rowData);
					}else{
						saveSpeaker(rowData);
					}
				break;
				
				case 'session':
					if(rowData.update){
						updateSession(rowData);
					}else{
						saveSession(rowData);
					}
				break;
				
				case 'timeslot':
					if(rowData.update){
						updateTimeslot(rowData);
					}else{
						saveTimeslot(rowData);
					}
				break;
				
				case 'mySchedule':
					if(rowData.update){
						updateMySchedule(rowData);
					}else{
						saveMySchedule(rowData);
					}
				break;
				
			}
			
		}
		
		public void function saveNotification(data){
			queryExecute('INSERT INTO notifications (notificationID, subject,notification, notificationread,createdDate,deleted) VALUES (?,?,?,?,?,?)',[data.notificationID,data.subject,data.notification,'0',data.createdDateTime,data.deleted],{"datasource":#window.dsName#});
		}
		
		public void function updateNotification(data){
			queryExecute('UPDATE notifications SET subject=?, notification=?, notificationread=0, deleted=? WHERE notificationid=?',[data.subject,data.notification,data.deleted,data.notificationID],{"datasource":#window.dsName#});
		}
		
		public void function saveDay(data){
			queryExecute('INSERT INTO day (dayID,title,dayDate,createdDate,deleted) VALUES (?,?,?,?,?)',[data.dayID,data.title,data.dayDate,data.createdDateTime,data.deleted],{"datasource":#window.dsName#});
		}
		
		public void function updateDay(data){
			queryExecute('UPDATE day SET title=?, daydate=?,deleted=? WHERE dayid=?',[data.title,data.dayDate,data.deleted,data.dayID],{"datasource":#window.dsName#});
		}
		
		public void function saveTrack(data){
			queryExecute('INSERT INTO track (trackID,title,createdDate,deleted) VALUES (?,?,?,?)',[data.trackID,data.title,data.createdDateTime,data.deleted],{"datasource":#window.dsName#});
		}
		
		public void function updateTrack(data){
			queryExecute('UPDATE track SET title=?,deleted=? WHERE trackID=?',[data.title,data.deleted,data.trackID],{"datasource":#window.dsName#});
		}
		
		public void function saveSpeaker(data){
			queryExecute('INSERT INTO speaker(speakerID,firstname,lastname,company,title,headshot,bio,createdDate,deleted) VALUES (?,?,?,?,?,?,?,?,?)',[data.speakerID,data.firstName,data.lastName,data.company,data.title,data.headshot,data.bio,data.createdDateTime,data.deleted],{"datasource":#window.dsName#});
		}
		
		public void function updateSpeaker(data){
			queryExecute('UPDATE speaker SET firstname=?,lastname=?,company=?,title=?,headshot=?,bio=?,deleted=? WHERE speakerID=?',[data.firstName,data.lastName,data.company,data.title,data.headshot,data.bio,data.deleted,data.speakerID],{"datasource":#window.dsName#});
		}
		
		public void function saveSession(data){
			queryExecute('INSERT INTO session (sessionID,title,speakerID,timeslotid,trackID,description,createdDate,deleted) VALUES (?,?,?,?,?,?,?,?)',[data.sessionID,data.title,data.speakerID,data.timeslotID,data.trackID,data.description,data.createdDateTime,data.deleted],{"datasource":#window.dsName#});
		}
		
		public void function updateSession(data){
			queryExecute('UPDATE session SET title=?, speakerID=?,timeslotID=?,trackID=?,description=?,deleted=? WHERE sessionID=?',[data.title,data.speakerID,data.timeslotID,data.trackID,data.description,data.deleted,data.sessionID],{"datasource":#window.dsName#});
		}	
		
		public void function saveTimeslot(data){
			queryExecute('INSERT INTO timeslot (timeslotID,dayID,title,global,createdDate,deleted,startTime,endTime) VALUES (?,?,?,?,?,?,?,?)',[data.timeslotID,data.dayID,data.title,trueFalseFormat(data.global),data.createdDateTime,data.deleted,data.startTime,data.endTime],{"datasource":#window.dsName#});
		}
		
		public void function updateTimeslot(data){
			queryExecute('UPDATE timeslot SET dayID=?, title=?,global=?,deleted=?, startTime=?, endTime=? WHERE timeslotID=?',[data.dayID,data.title,trueFalseFormat(data.global),data.deleted,data.startTime,data.endTime,data.timeslotID],{"datasource":#window.dsName#});
		}	
		
		public boolean function saveSurveyLocal(data){
			if(len(trim(data.surveyID))){
				queryExecute('UPDATE survey SET q1=?,q2=?,q3=?,q4=?,q5=?,notes=?,synched=? WHERE surveyID=?',[data.q1,data.q2,data.q3,data.q4,data.q5,data.notes,0,data.surveyID],{"datasource":#window.dsName#});
			}else{
				queryExecute('INSERT INTO survey (surveyID,sessionID,q1,q2,q3,q4,q5,notes,synched,createdDate) VALUES (?,?,?,?,?,?,?,?,?,?)',[createUUID(),data.sessionID,data.q1,data.q2,data.q3,data.q4,data.q5,data.notes,0,now()],{"datasource":#window.dsName#});
			}
		}
		
		public boolean function saveMySchedule(data){
			queryExecute('INSERT INTO MySchedule (scheduleItemID,sessionID,createdDate,modifiedDate,deleted,synched) VALUES (?,?,?,?,?,?)',[data.scheduleItemID,data.sessionID,data.createdDateTime,data.modifiedDateTime,data.deleted,data.synched],{"datasource":#window.dsName#});
		}
		
		public void function updateMySchedule(data){
			queryExecute('UPDATE MySchedule SET deleted=?,synched=? WHERE sessionID=?',[data.deleted,data.synched,data.sessionID],{"datasource":#window.dsName#});
		}
		
		public void function wipeDatabase(){
			queryExecute('delete from notifications',[],{"datasource":#window.dsName#});
			queryExecute('delete from session',[],{"datasource":#window.dsName#});
			queryExecute('delete from speaker',[],{"datasource":#window.dsName#});
			queryExecute('delete from MySchedule',[],{"datasource":#window.dsName#});
			queryExecute('delete from track',[],{"datasource":#window.dsName#});
			queryExecute('delete from day',[],{"datasource":#window.dsName#});
			queryExecute('delete from timeslot',[],{"datasource":#window.dsName#});
			queryExecute('delete from survey',[],{"datasource":#window.dsName#});
			
			queryExecute('drop table notifications',[],{"datasource":#window.dsName#});
			queryExecute('drop table session',[],{"datasource":#window.dsName#});
			queryExecute('drop table speaker',[],{"datasource":#window.dsName#});
			queryExecute('drop table MySchedule',[],{"datasource":#window.dsName#});
			queryExecute('drop table track',[],{"datasource":#window.dsName#});
			queryExecute('drop table day',[],{"datasource":#window.dsName#});
			queryExecute('drop table timeslot',[],{"datasource":#window.dsName#});
			queryExecute('drop table survey',[],{"datasource":#window.dsName#});
			
			invokeInSyncMode(createTables());
			setLastUpdateDate(' ');
		}
		
		public void function setLastUpdateDate(updateDate = now()){
			cfclient.localstorage.setItem('dbLastUpdatedDate',updateDate);
		}
		
		public void function clearLastUpdateDate(updatedDate=now()){
			cfclient.localstorage.setItem('dbLastUpdatedDate','');
		}
		
		public void function getLastUpdateDate(){
			try{
				return cfclient.localstorage.getItem('dbLastUpdatedDate');
			}catch (any e){
				return '';
			}
		}
		
		
		/*Helper Functions*/
		
		public boolean function trueFalseFormat(value){
			if(value eq '1' OR value eq 'true' or value eq true){
				return true;
			}else{
				return false;
			}
		}
		
	</cfscript>		
</cfclient>