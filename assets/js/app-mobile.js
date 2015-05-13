/******
Helper Functions - Mobile Specific

***/

function displayPage(page,content,allowSidePanel){

	snapper.close();
	if(content){
		$('#' + page).html(content);
	}
	$('.navpage').hide();
	$('#' + page).show();
	
}

/* Snap.js functions*/
var snapper = new Snap({
    element: document.getElementById('content'),
    disable: 'right'
});

$('.mainMenuButton').click(function(){
	if( snapper.state().state=="left" ){
		snapper.close();
	} else {
		snapper.open('left');
	}
	return false;
});

