var routes = {
        '/home': app.viewHome,
        '/sessions': app.viewSessions,
        '/speakers': app.viewSpeakers,
        '/session/view/:sessionID': app.viewSession,
        '/speaker/view/:speakerID': app.viewSpeaker,
        '/schedule/': app.viewSchedule,
        '/myschedule': app.viewMySchedule,
        '/notifications': app.viewNotifications,
        '/survey/:surveyID': app.viewSurvey,
        '/location': app.viewLocation,
        '/twitterFeed': app.viewTwitterFeed,
        '/about': app.viewAbout,
        '/login': app.viewLogin,
        '/settings': app.viewSettings
      };
      
