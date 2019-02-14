function bs_input_file() {
	$(".input-file").before(
		function() {
			if ( ! $(this).prev().hasClass('input-ghost') ) {
				var element = $("<input type='file' class='input-ghost' style='visibility:hidden; height:0'>");
				element.attr("name",$(this).attr("name"));
				element.change(function(){
					element.next(element).find('input').val((element.val()).split('\\').pop());
				});
				
				$(this).find("button.btn-choose").click(function(){
					element.click();
				});
				
				$(this).find("button.btn-reset").click(function(){
					element.val(null);
					$(this).parents(".input-file").find('input').val('');
				});
				$(this).find('input').css("cursor","pointer");
				$(this).find('input').mousedown(function() {
					$(this).parents('.input-file').prev().click();
					return false;
				});
				return element;
			}
		}
	);
}
$(function() {
	bs_input_file();
});

$(document).ready(function() {
    $("ul.dropdown-menu input[type=checkbox]").each(function() {
        $(this).change(function() {
            var line = "";
            $("ul.dropdown-menu input[type=checkbox]").each(function() {
                if($(this).is(":checked")) {
                	if($("+ span", this).text() != "Evaluate All"){
                    	line += $("+ span", this).text() + ";";
                    }
                }
            });
            $("#subsystems").val(line);
        });
    });
});

$('#evaluateAll').change(function() {
    var checkboxes = $(this).closest('form').find(':checkbox');
    checkboxes.prop('checked', $(this).is(':checked'));
});

$("#skitt-toggle-button").click(function() {
	// Init the browser's own Speech Recognition
	var recognition = new webkitSpeechRecognition();
	
	// Tell KITT the command to use to start listening
	SpeechKITT.setStartCommand(function() {recognition.start()});
	
	// Tell KITT the command to use to abort listening
	SpeechKITT.setAbortCommand(function() {recognition.abort()});
	
	// Register KITT's recognition start event with the browser's Speech Recognition
	recognition.addEventListener('start', SpeechKITT.onStart);
	
	// Register KITT's recognition end event with the browser's Speech Recognition
	recognition.addEventListener('end', SpeechKITT.onEnd);
	
	// Define a stylesheet for KITT to use
	SpeechKITT.setStylesheet('//cdnjs.cloudflare.com/ajax/libs/SpeechKITT/1.0.0/themes/flat.css');
	
	// Render KITT's interface
	SpeechKITT.vroom(); // SpeechKITT.render() does the same thing, but isn't as much fun!
});