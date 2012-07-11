(function styleizefilebutton() {

	function stylizeInput (el) {
		if (!el) return;
		var input = el.down('input[type=file]');
               var agt = navigator.userAgent.toLowerCase();
                if (agt.indexOf("chrome") != -1)
                  {
                    var  fixFactor = -15;
                  }
                  else
                  {
                    var  fixFactor = 30;
                  }

                if (input) {
			el.observe("mousemove", function(event) {
				//input.setStyle({ left: (event.pointerX() - this.positionedOffset()['left']) - (input.getWidth() - fixFactor) + 'px' });
			}).wrap('div', {'class' : 'solidhex-stylized'}).insert({bottom: '<div id="status" style="display:none">No file selected</div>'});

			updateFile(input);

			input.observe("change", function() {
				(updateFile(this));
			});
                               }
                        }

	function updateFile (file) {
		$('status').update(file.value)
	}

	function init () {
		$$('div.file').each(stylizeInput);
	}


	document.observe("dom:loaded", init)

})();


	function stylizeInput (el) {
		if (!el) return;
		var input = el.down('input[type=file]');
               var agt = navigator.userAgent.toLowerCase();

                if (agt.indexOf("chrome") != -1)
                  {
                      fixFactor=0;
                  }
                  else
                  {
                      fixFactor=30;
                  }
                if (input) {
			el.observe("mousemove", function(event) {
				//input.setStyle({ left: (event.pointerX() - this.positionedOffset()['left']) - (input.getWidth() - fixFactor) + 'px' });
			}).wrap('div', {'class' : 'solidhex-stylized'}).insert({bottom: '<div id="status" style="display:none">No file selected</div>'});

			updateFile(input);

			input.observe("change", function() {
				(updateFile(this));
			});
                               }
                        }

	function updateFile (file) {
		$('status').update(file.value)
	}

	function initStylizeInput () {
		$$('div.file').each(stylizeInput);
	}




//function styleizefilebutton() {
//
//	function stylizeInput (el) {
//		if (!el) return;
//		var input = el.down('input[type=file]');
//		 if (agt.indexOf("chrome") != -1)
//                  {
//                      fixFactor=0;
//                  }
//                  else
//                  {
//                      fixFactor=30;
//                  }
//                if (input) {
//			el.observe("mousemove", function(event) {
//				input.setStyle({ left: (event.pointerX() - this.positionedOffset()['left']) - (input.getWidth() - fixFactor) + 'px' });
//			}).wrap('div', {'class' : 'solidhex-stylized'}).insert({bottom: '<div id="status" style="display:none">No file selected</div>'});
//
//			updateFile(input);
//
//			input.observe("change", function() {
//				(updateFile(this));
//			});
//		}
//	}
//
//	function updateFile (file) {
//		$('status').update(file.value)
//	}
//
//	function init () {
//		$$('div.file').each(stylizeInput);
//	}
//
//
//	$$('div.file').each(stylizeInput);
//
//}