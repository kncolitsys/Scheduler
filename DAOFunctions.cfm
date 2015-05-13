<cfclient>
	<cfscript>
		/**********
		Select Queries
		**********/
		
		
		public any function getNotifications(){
			var qNotifications = queryExecute('SELECT * FROM notifications ORDER BY createdDate DESC',[],{"datasource":#window.dsName#});
			return JSON.stringify(queryToObject(qNotifications));
		}

		public query function getDays(){
			var tmp = queryExecute('SELECT * FROM day ORDER BY dayDate',[],{"datasource":#window.dsName#});
			return tmp;
		}
		
		public any function getTimeslots(dayID){
			var tmp=queryExecute('SELECT * FROM timeslot WHERE dayID=? order by startTime, endTime',[dayID],{"datasource":#window.dsName#});;
			return tmp;
		}
			
		public any function getSessionsByTimeslot(timeslotID){
			var tmp=queryExecute('SELECT *,session.sessionid,session.title as sessiontitle,track.title as track FROM session INNER JOIN speaker on session.speakerID = speaker.speakerID INNER JOIN track on session.trackID = track.trackID WHERE timeslotID=?',[timeslotID],{"datasource":#window.dsName#});;
			return tmp;
		}		
		
		public any function getMySessionsByTimeslot(timeslotID){
			var tmp=queryExecute('SELECT *,session.title as sessiontitle,track.title as track FROM session INNER JOIN speaker on session.speakerID = speaker.speakerID INNER JOIN track on session.trackID = track.trackID INNER JOIN MySchedule ON session.sessionID = MySchedule.sessionID  WHERE timeslotID=? AND mySchedule.deleted=0  order by startTime, endTime',[timeslotID],{"datasource":#window.dsName#});;
			return tmp;
		}	
		
		public any function getSessions(){
			var qSessions = queryExecute('SELECT * FROM session LEFT OUTER JOIN speaker ON session.speakerID = speaker.speakerID ORDER BY session.title',[],{"datasource":#window.dsName#});
			return JSON.stringify(queryToObject(qSessions));
		}
		
		public any function getSession(id){
			var qSession = queryExecute("SELECT session.*,speaker.firstname, speaker.lastname, speaker.headshot, track.title as track FROM session INNER JOIN speaker on session.speakerID = speaker.speakerID INNER JOIN track on session.trackID=track.trackID WHERE session.sessionid = ?",[id],{"datasource":#window.dsName#});
			var obj = rowToObject(qSession);
			obj.inSchedule=myScheduleCheck(id);
			obj.surveyTaken=surveyCheck(id);
			return JSON.stringify(obj);
		}
		
		public boolean function myScheduleCheck(id){
			var qSession = queryExecute("SELECT * FROM mySchedule WHERE sessionid = ? AND deleted = 0",[id],{"datasource":#window.dsName#});
			
			if(queryToObject(qSession).length){
				return true;
			}else{
				return false;
			}
		}
		
		public boolean function surveyCheck(id){
			var qSurvey = queryExecute("SELECT surveyID FROM survey WHERE sessionid = ?",[id],{"datasource":#window.dsName#});
			
			if(queryToObject(qSurvey).length){
				return true;
			}else{
				return false;
			}
		}
		
		public any function getSpeakers(){
			var qSpeakers = queryExecute('SELECT * FROM speaker ORDER BY lastname DESC,firstname DESC',[],{"datasource":#window.dsName#});
			return JSON.stringify(queryToObject(qSpeakers));
		}
		
		public any function getSpeaker(id){
			var qSpeaker = queryExecute('SELECT * FROM speaker WHERE speakerid = ?',[id],{"datasource":#window.dsName#});
			var qSessions = queryExecute('SELECT * FROM session WHERE speakerid = ?',[id],{"datasource":#window.dsName#});
			var speakerObj = rowToObject(qSpeaker);
			speakerObj.sessions = rowToObject(qSessions);
			
			return JSON.stringify(speakerObj);
		}
		
		public any function getUnsynchedData(){
			var qScheduleItems = queryExecute('SELECT * FROM mySchedule WHERE synched=0',[],{"datasource":#window.dsName#});
			var qSurveyItems = queryExecute('SELECT * FROM survey WHERE synched=0',[],{"datasource":#window.dsName#});
			return JSON.stringify({mySchedule:queryToObject(qScheduleItems),survey:queryToObject(qSurveyItems)});
		}
		
		public any function getSurveyData(id){
			var qSurvey = queryExecute('SELECT session.sessionID, session.title, speaker.firstname, speaker.lastname, survey.* FROM session INNER JOIN speaker on session.speakerID = speaker.speakerID LEFT OUTER JOIN survey on session.sessionID = survey.sessionID WHERE session.sessionid = ?',[id],{"datasource":#window.dsName#});
			return rowToObject(qSurvey);
		}
		
		public any function getNotificationCount(){
			var qNotifications = queryExecute('SELECT count(notificationID) as tot FROM notifications WHERE notificationread=0',[],{"datasource":#window.dsName#});
			return qNotifications.tot;
		}
		
		public void function markNotificationsRead(){
			var qNotifications = queryExecute('UPDATE notifications SET notificationread=1',[],{"datasource":#window.dsName#});
			return ;
		}
		
		
		/*******
		Update Functions
		*******/

		public any function addToMySchedule(sessionID){
			saveMySchedule({scheduleItemID:createUUID(),sessionID:sessionID,createdDateTime:now(),modifiedDateTime:'',deleted:0,synched:0});
		}
		
		
		public any function removeFromSchedule(sessionID){
			updateMySchedule({sessionID:sessionID,modifiedDateTime:now(),deleted:1,synched:0});
		}
		
		public void function updateSynchData(){
			queryExecute('UPDATE MySchedule SET synched=1',[],{"datasource":#window.dsName#});
			queryExecute('UPDATE survey SET synched=1',[],{"datasource":#window.dsName#});
		}

		/********
			Table Creation Functions
		********/
		public boolean function createTables(){
			createNotificationTable();
			createSessionTable();
			createSpeakerTable();
			createMyScheduleTable();
			createTrackTable();
			createDayTable();
			createTimeslotTable();
			createSurveyTable();
			
			return true;
		}				
		
		public void function createNotificationTable(){
			queryExecute('create table if not exists notifications (notificationID text, subject text, notification text,notificationread boolean,createdDate datetime,deleted boolean);',[],{"datasource":#window.dsName#});
			return;
		}
		
		public void function createScheduleTable(){
			queryExecute('create table if not exists Schedule (scheduleID text,displayDate date, name text, createdDate datetime);',[],{"datasource":#window.dsName#});
			return;
		}
		
		public void function createScheduleItemTable(){
			queryExecute('create table if not exists ScheduleItem (scheduleItemID text,scheduleID text, sessionID text, type text, startTime datetime, endTime datetime, createdDate datetime,deleted boolean);',[],{"datasource":#window.dsName#});
			return;
		}
		
		public void function createSessionTable(){
			queryExecute('create table if not exists session (sessionID text,title text, speakerID text, trackID text, timeslotID text, description text, createdDate datetime,deleted boolean);',[],{"datasource":#window.dsName#});
			return;
		}
		
		public void function createSpeakerTable(){
			queryExecute('create table if not exists speaker (speakerID text,firstname text, lastname text, company text, title text, headshot text, bio text, createdDate datetime,deleted boolean);',[],{"datasource":#window.dsName#});
			return;
		}
		
		public void function createMyScheduleTable(){
			queryExecute('create table if not exists MySchedule (scheduleItemID text,sessionID text, createdDate datetime, modifiedDate datetime, removed boolean,deleted boolean, synched boolean);',[],{"datasource":#window.dsName#});
			return;
		}
		
		public void function createTrackTable(){
			queryExecute('create table if not exists track (trackID text,title text, createdDate datetime,deleted boolean);',[],{"datasource":#window.dsName#});
			return;
		}
		
		public void function createDayTable(){
			queryExecute('create table if not exists day (dayID text,title text, dayDate date, createdDate datetime,deleted boolean);',[],{"datasource":#window.dsName#});
			return;
		}
		
		public void function createTimeslotTable(){
			queryExecute('create table if not exists timeslot (timeslotID text, dayID text,title text, global boolean, createdDate datetime,deleted boolean, startTime time, endTime time);',[],{"datasource":#window.dsName#});
			return;
		}
		
		public void function createSurveyTable(){
			queryExecute('create table if not exists survey (surveyID text, sessionID text, q1 int, q2 int, q3 int, q4 int, q5 int, notes text, synched boolean, createdDate datetime);',[],{"datasource":#window.dsName#});
			return;
		}
		
		
		/************
		helper function
		*************/
		
		public any function getSchedule(){
			var qDays=queryToObject(getDays());
			var aDays=[];
			
			for(day in qDays){
				var objDay={title:day.title,dayid:day.dayid,date:day.daydate,active:false,timeslots:[]};
				
				var qTimeslots = queryToObject(getTimeslots(day.dayid));
				
				for(timeslot in qTimeslots){
					
					var objTimeslot={title:timeslot.title,global:false,tracks:false,sessions:[]};
					
					if(timeslot.global eq 'true'){
						objTimeslot.global=true;
						objTimeslot.tracks=false;
					}else{
						objTimeslot.global=false;
						objTimeslot.tracks=true;
					}
					
					var qSessions = queryToObject(getSessionsByTimeslot(timeslot.timeslotid));
					for(sessionObj in qSessions){
						arrayAppend(objTimeslot.sessions,{
							name:sessionObj.sessiontitle,
							//speaker:sessionObj.firstname & ' ' & sessionObj.lastname,
							headshot:sessionObj.headshot,
							sessionID:sessionObj.sessionid,
							speakerID:sessionObj.speakerid,
							track:sessionObj.track,
							trackID:sessionObj.trackid
						});
					}
					
					arrayAppend(objDay.timeslots,objTimeslot);
				}
				
				arrayAppend(aDays,objDay);
			}
			
			return JSON.stringify(aDays);
		}
		
		public any function getMySchedule(){
			var qDays=queryToObject(getDays());
			var aDays=[];
			
			for(day in qDays){
				var objDay={title:day.title,dayid:day.dayid,date:day.daydate,active:false,timeslots:[]};
				
				var qTimeslots = queryToObject(getTimeslots(day.dayid));
				
				for(timeslot in qTimeslots){
					
					var objTimeslot={title:timeslot.title,global:false,tracks:false,sessions:[]};
					
					if(timeslot.global eq 'true'){
						objTimeslot.global=true;
						objTimeslot.tracks=false;
					}else{
						objTimeslot.global=false;
						objTimeslot.tracks=true;
					}
					
					var qSessions = queryToObject(getMySessionsByTimeslot(timeslot.timeslotid));
					
					for(sessionObj in qSessions){
						arrayAppend(objTimeslot.sessions,{
							name:sessionObj.sessiontitle,
							//speaker:sessionObj.firstname & ' ' & sessionObj.lastname,
							sessionID:sessionObj.sessionid,
							speakerID:sessionObj.speakerid,
							track:sessionObj.track,
							trackID:sessionObj.trackid
						});
					}
					
					arrayAppend(objDay.timeslots,objTimeslot);
				}
				
				arrayAppend(aDays,objDay);
			}
			
			return JSON.stringify(aDays);
		}
		
	</cfscript>		
</cfclient>