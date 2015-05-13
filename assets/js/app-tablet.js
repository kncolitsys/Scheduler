/******
Helper Functions - Tablet Specific

***/

function displayPage(page,content,allowSidePanel){
	if(allowSidePanel){
		if(content){
			$('#rightPanelContent').html(content);
		}	
		displayRightColumn();
	}else{
		closeRightColumn()
		if(content){
			$('#' + page).html(content);
		}
		$('.navpage').hide();
		$('#' + page).show();
	}
}

function displayRightColumn(){
	$('#rightPanel').animate({right:'0px'});
	//$('.pageContentWrapper').animate({width:'800px'});
}

function closeRightColumn(){
	if($('#rightPanel').css('right') == '0px'){
		$('#rightPanel').animate({right:'-466px'});
	}
}

$('#rightPanel').on('click','#rightPanelClose',function(){
	closeRightColumn();
})