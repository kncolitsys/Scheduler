var app = {

	isOnline: false,
	userID:'',		
	init: function () {
		"use strict";
		app.bindEvents();
		app.docReady();
	},
	
	bindEvents: function () {
		"use strict";
		$('body').on('click','.nav-link',function(){
			$('.day').hide();
			$('#' + $(this).attr('day')).show();
			$('.nav-link').removeClass( "active" );
			$(this).addClass( "active" );
		});
		
		$('body').on('click','.nav-link-my-schedule',function(){
			$('.day').hide();
			$('#mySchedule' + $(this).attr('day')).show();
			$('.nav-link-my-schedule').removeClass( "active" );
			$(this).addClass( "active" );
		});
		
		$('body').on('click','.notificationItem',function(){
			var notificationBody = $(this).children()[2]
			if($(notificationBody).css('display') == 'none'){
				$(notificationBody).show();
				$(this).find('.expand').html('<img src="assets/images/arrow-up.png"/>');
			}else{
				$(notificationBody).hide();
				$(this).find('.expand').html('<img src="assets/images/arrow-down.png"/>');
			}
		});
		
		$('body').on('click','.expand',function(){
			
			if($('.notificationBody',$(this).parent().parent()).css('display') == 'none'){
				$('.notificationBody',$(this).parent().parent()).show();
				$(this).html('<img src="assets/images/arrow-up.png"/>');
			}else{
				$('.notificationBody',$(this).parent().parent()).hide();
				$(this).html('<img src="assets/images/arrow-down.png"/>');
			}
		});
		
		$('body').on('click','#loginSubmit',function(){
			
			$.ajax({
			  type: 'GET',
				  url: 'http://app.simonfree.com/account.cfc?method=login',
				 data: { username: $('#username').val(), password: $('#password').val() },
				  dataType: 'json',
				  success: function(data){
				  	if(data.SUCCESS){
				  		app.setLoginCredentials(data.LOGINTOKEN);
				  		app.setUserID(data.LOGINTOKEN);
				  		$('#navigationBtn').show();
						$(".notificationButton").show();
						app.viewHome();
				  	}else{
				  		$('#loginStatus').html(data.MESSAGE);
				  		$('#loginStatus').show();
				  	}
				  },
				  error: function(xhr, type){
				  	console.log('error');
				    console.log(type);
				    console.log(xhr);
				  }
				});
		});
		
		$('body').on('click','.addToSchedule', function(e){
			e.preventDefault();
			
			addToMySchedule($(this).attr('sessionID'));
			$('.addToSchedule').hide();
			$('.removeFromSchedule').show();
			dataSynch.pushUpdates();
		});	
		
		$('body').on('click','.removeFromSchedule',function(e){
			e.preventDefault();
			
			removeFromSchedule($(this).attr('sessionID'));
			$('.removeFromSchedule').hide();
			$('.addToSchedule').show();
			dataSynch.pushUpdates();
			
		});	
		
		$('body').on('click','#synchDataButton',function(){
			dataSynch.checkForDataUpdates();
			app.viewAbout();
		});
		
		$('body').on('click','#saveSettingsButton',function(){
			invokeCFClientFunction('saveApplicationSettings', {dataUpdateFrequency:$('#dataUpdateFrequency').val(),twitterCount:$('#twitterCount').val(),saveURL:$('#saveURL').val(),updateURL:$('#updateURL').val()}, function(){
				$('#settingsNotification').show();
			});	
		});
		
		$('body').on('click','#clearDatabaseButton', function(){
			dataSynch.resetDatabase();
			
			invokeCFClientFunction('clearLastUpdateDate');	
			$('#settingsNotification').html('Database has been cleared');
			$('#settingsNotification').show();
		});
		
		
		$('body').on('click','#saveSurveysButton', function(){
			app.submitSurvey();
		})
		
	},
	docReady: function () {
		"use strict";
		app.checkNotifications();
		invokeCFClientFunction('checkLogin', function(loginCheck) {
			if(loginCheck.success == true){
				app.setUserID(loginCheck.userID);
				$('#navigationBtn').show();
				$(".notificationButton").show();
				app.viewHome();
			}else{
				app.viewLogin();
			}
		});	
		
	},
	setLoginCredentials: function(credentials){
		invokeCFClientFunction('setLoginCredentials',credentials,null);	
	},
	checkNotifications: function(){
		invokeCFClientFunction('getNotificationCount', function(data) {
			app.updateNotifications(data);
		});	
	},
	submitSurvey: function(){
		saveSurveyLocal({
				surveyID:$('#surveyID').val(),
				sessionID:$('#sessionID').val(),
				q1:getCheckBoxValue('q1'),
				q2:getCheckBoxValue('q2'),
				q3:getCheckBoxValue('q3'),
				q4:getCheckBoxValue('q4'),
				q5:getCheckBoxValue('q5'),
				notes:$('#notes').val()
			});
		app.viewSession($('#sessionID').val());
		
		dataSynch.pushUpdates();
		
	},
	updateNotifications: function(count){
		if(parseInt(count) > 0){
			$('.notificationCounter').show();
			var oldCount = parseInt($('.notificationCounter').html());
			
			if(parseInt(count)>10){
				$('.notificationCounter').html('10+');
			}else{
				$('.notificationCounter').html(count);
			}
			
			if(oldCount != parseInt(count)){
				dispatchNotificationVibration();
			}
		}else{
			$('.notificationCounter').hide();
		}
	},
	viewHome: function(){
		displayPage('homePage',null,false);
	},
	viewSessions: function(){
		invokeCFClientFunction('getSessions', function(data) {
			var content = Mustache.to_html($('#sessionsTmpl').html(), {sessions:JSON.parse(data)});
			displayPage('sessionsPage',content,false);
		});	
	},
	viewSpeakers: function(){
		invokeCFClientFunction('getSpeakers', function(data) {
			var content = Mustache.to_html($('#speakersTmpl').html(), {speakers:JSON.parse(data)});
			displayPage('speakersPage',content,false);
		});
	},
	viewSession: function(id){
		invokeCFClientFunction('getSession',id, function(data) {
			var content = Mustache.to_html($('#sessionTmpl').html(), JSON.parse(data));
			displayPage('sessionPage',content,true);
		});
	},
	viewSpeaker: function(id){
		invokeCFClientFunction('getSpeaker',id, function(data) {
			var content = Mustache.to_html($('#speakerTmpl').html(), JSON.parse(data));
			displayPage('speakerPage',content,true);
		});
	},
	viewSchedule: function(){
		invokeCFClientFunction('getSchedule', function(data) {
			var scheduleData = JSON.parse(data);
			scheduleData[0].active=true;
			
			var content = Mustache.to_html($('#scheduleTmpl').html(), {schedule:scheduleData});
			displayPage('schedulePage',content,false);
		});
	},
	viewMySchedule: function(){
		invokeCFClientFunction('getMySchedule', function(data) {
			var scheduleData = JSON.parse(data);
			scheduleData[0].active=true;
			
			var content = Mustache.to_html($('#myScheduleTmpl').html(), {schedule:scheduleData});
			displayPage('mySchedulePage',content,false);
		});
	},
	viewNotifications: function(){
		invokeCFClientFunction('getNotifications', function(data) {
			var content = Mustache.to_html($('#notificationsTmpl').html(), {notifications:JSON.parse(data)});
			displayPage('notificationPage',content,false);
		});
		
		invokeCFClientFunction('markNotificationsRead');
		app.updateNotifications('0');
	},
	viewSurvey: function(id){
		invokeCFClientFunction('getSurveyData',id, function(data) {
			var content = Mustache.to_html($('#surveyTmpl').html(), data);
			displayPage('surveyPage',content,false);
			
			setCheckBox('q1',data.q1);
			setCheckBox('q2',data.q2);
			setCheckBox('q3',data.q3);
			setCheckBox('q4',data.q4);
			setCheckBox('q5',data.q5);
		});
		
	},
	viewTwitterFeed: function(){
		
		if(dataSynch.isOnline){
			snapper.close();
			app.showLoading();
			invokeCFClientFunction('getApplicationSettings', function(data) {
				searchTwitter(data.twitterTerm,data.twitterCount);
			});
		}else{
			displayPage('twitterPage','<div class="subpage"><p>No Internet Connection</p></div>',false);
		}
		
	},
	viewAbout: function(){
		
		invokeCFClientFunction('getLastUpdateDate', function(data) {
			var content = Mustache.to_html($('#aboutTmpl').html(), {lastUpdatedDate:data});
			displayPage('aboutPage',content,false);
		});
	},
	viewLogin: function(){
		displayPage('loginPage',null,false);
	},
	viewSettings: function(){
		invokeCFClientFunction('getApplicationSettings', function(data) {
			var content = Mustache.to_html($('#settingsTmpl').html(), data);
			displayPage('settingsPage',content,false);
		});
	},
	displayTweets: function(data){
		var tweets=[];
		
		$(data.statuses).each(function(i,value){
			var created = new Date(value.created_at);
			
			tweets.append({
				message:value.text,
				user:value.user,
				created:created.toLocaleDateString() + " " + created.toLocaleTimeString() 
			});
		});
		
		app.hideLoading();
		
		var content = Mustache.to_html($('#twitterTmpl').html(), {tweets:tweets});
		displayPage('twitterPage',content,false);
	},
	showLoading: function(){
		$('#waiting').show();
	},
	hideLoading: function(){
		$('#waiting').hide();
	},
	getUserID: function(){
		return app.userID;
	},
	setUserID: function(userID){
		app.userID=userID;
	}
	
}	

/******
Utility Functions
*****/

var queryToObject = function(q) {
    var col, i, r, _i, _len, _ref, _ref2, _results;
    _results = [];
    for (i = 0, _ref = q.ROWCOUNT; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
      r = {};
      _ref2 = q.COLUMNS;
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        col = _ref2[_i];
        r[col.toLowerCase()] = q.DATA[col][i];
      }
      _results.push(r);
    }

    return _results;
  };
  
var rowToObject = function(q) {
    var col, i, r, _i, _len, _ref, _ref2, _results;
      r = {};
      _ref2 = q.COLUMNS;
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        col = _ref2[_i];
        r[col.toLowerCase()] = q.DATA[col][0];
      }
    return r;
  };  


$(document).ready(function(){
	$('.pageContentWrapper').on('click','.checker',function(e){
		e.preventDefault();
		$(this).parent().find('.checked').removeClass('checked');
		$(this).addClass('checked');
	})
});

function getCheckBoxValue(group){
	return $('.checked.' + group ).html();
}

function setCheckBox(selector, value){
	$("." + selector + ":contains('" + value + "')").addClass('checked');
}



