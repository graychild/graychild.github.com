$(document).ready( function() {
	$('.slideshow').each( function(i) {
		var ul = $(this);
		if (ul.find('li').length == 1) {
			ul.photoShow( {
				input:    'html',
				width:    '640px',
				height:   '480px',
				controls: [ ]
			} );
		} else {
			ul.photoShow( {
				input:    'html',
				width:    '640px',
				height:   '480px',
				controls: ['prev', 'autoplay', 'thumbs', 'next']
			} );
		}
	} );

	$('#page_content').fadeIn();
	$('#page_background').height($('#page_content').height());
	$('#page_background').show();

	$('#older_posts_link').click( function() {
		$(this).hide();
		$('#older_posts').fadeIn();
		$('#page_background').height($('#page_content').height());
	} );
} );
