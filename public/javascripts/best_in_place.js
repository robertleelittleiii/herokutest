/*
        BestInPlace (for jQuery)
        version: 0.1.0 (01/01/2011)
        @requires jQuery >= v1.4
        @requires jQuery.purr to display pop-up windows

        By Bernat Farrero based on the work of Jan Varwig.
        Examples at http://bernatfarrero.com

        Licensed under the MIT:
          http://www.opensource.org/licenses/mit-license.php

        Usage:

        Attention.
        The format of the JSON object given to the select inputs is the following:
        [["key", "value"],["key", "value"]]
        The format of the JSON object given to the checkbox inputs is the following:
        ["falseValue", "trueValue"]
*/
var notice = ""

function setUpPurrNotifier(headline, message)
{
    var notice = '<div class="notice">'
    + '<div class="notice-body">'
    + '<img src="../static/images/icons/info.png" />'
    + '<h3>' + headline + '</h3>'
    + '<p>' + message + '</p>'
    + '</div>'
    + '<div class="notice-bottom">'
    + '</div>'
    + '</div>';
    
}
var notice = ""

function setUpPurrNotifier(headline, message)
{
    var notice = '<div class="notice">'
    + '<div class="notice-body">'
    + '<img src="../static/images/icons/info.png" />'
    + '<h3>' + headline + '</h3>'
    + '<p>' + message + '</p>'
    + '</div>'
    + '<div class="notice-bottom">'
    + '</div>'
    + '</div>';
    
}
    function wait(msecs)
{
var start = new Date().getTime();
var cur = start
while(cur - start < msecs)
{
cur = new Date().getTime();
}	
} 
 function getInputSize(minWidth,comfortZone,inputField) 
 {
        var maxWidth = 5000;
        
        var minWidth = minWidth || $j(inputField).width();
            val = '';
            input = $j(inputField);
            testSubject = $j('<tester/>').css({
                position: 'absolute',
                top: -9999,
                left: -9999,
                width: 'auto',
                fontSize: input.css('fontSize'),
                fontFamily: input.css('fontFamily'),
                fontWeight: input.css('fontWeight'),
                letterSpacing: input.css('letterSpacing'),
                whiteSpace: 'nowrap'
            });
    if (val === (val = input.val())) {
        return;
    }
          
                console.log(input);
                
                // Enter new content into testSubject
                var escaped = val.replace(/&/g, '&amp;').replace(/\s/g,' ').replace(/</g, '&lt;').replace(/>/g, '&gt;');
                testSubject.html(escaped);

                // Calculate new width + whether to change
                var testerWidth = testSubject.width();
                    console.log(testerWidth);
                    newWidth = (testerWidth + comfortZone) >= minWidth ? testerWidth + comfortZone : minWidth;
                    console.log(newWidth);
                    currentWidth = input.width();
                    console.log(currentWidth);
                    isValidWidthChange = (newWidth < currentWidth && newWidth >= minWidth)
                                         || (newWidth > minWidth && newWidth < maxWidth);

                // Animate width
                if (isValidWidthChange) {
                  //  input.width(newWidth);
                }

            return(newWidth);
 }
 
 
 
    function autoGrowInput (o,inputField) {

    o = $j.extend({
        maxWidth: 1000,
        minWidth: 10,
        comfortZone: 10
    }, o);

    $j(inputField).filter('input:text').each(function(){

        var minWidth = o.minWidth || $j(inputField).width(),
            val = '',
            input = $j(inputField),
            testSubject = $j('<tester/>').css({
                position: 'absolute',
                top: -9999,
                left: -9999,
                width: 'auto',
                fontSize: input.css('fontSize'),
                fontFamily: input.css('fontFamily'),
                fontWeight: input.css('fontWeight'),
                letterSpacing: input.css('letterSpacing'),
                whiteSpace: 'nowrap'
            }),
            check = function() {

            if (val === (val = input.val())) {
                return;
            }
      
                // Enter new content into testSubject
                var escaped = val.replace(/&/g, '&amp;').replace(/\s/g,' ').replace(/</g, '&lt;').replace(/>/g, '&gt;');
                testSubject.html(escaped);

                // Calculate new width + whether to change
                var testerWidth = testSubject.width(),
                    newWidth = (testerWidth + o.comfortZone) >= minWidth ? testerWidth + o.comfortZone : minWidth,
                    currentWidth = input.width(),
                    isValidWidthChange = (newWidth < currentWidth && newWidth >= minWidth)
                                         || (newWidth > minWidth && newWidth < o.maxWidth);

                // Animate width
                if (isValidWidthChange) {
                    input.width(newWidth);
                }

            };

        testSubject.insertAfter(input);

        $j(this).bind('hover keyup keydown blur update focus', check);

    });

    return this;

};
// stub for success
 
function BestInPlaceCallBack(input) {
 
} ;
 
function BestInPlaceEditor(e) {
    this.element = jQuery(e);
    this.initOptions();
    this.bindForm();
    this.initNil();
    $j(this.activator).unbind('click');
    $j(this.activator).bind('click', {
        editor: this
    }, this.clickHandler);
}

BestInPlaceEditor.prototype = {
    // Public Interface Functions //////////////////////////////////////////////

    activate : function() {
        var elem = this.isNil ? "" : this.element.html();
        this.oldValue = elem;
        $j(this.activator).unbind("click", this.clickHandler);
        this.activateForm();
    },

    abort : function() {
        if (this.isNil) this.element.html(this.nil);
        else            this.element.html(this.oldValue);
        $j(this.activator).bind('click', {
            editor: this
        }, this.clickHandler);
    },

    update : function() {
        var editor = this;
        if (this.formType in {
            "input":1, 
            "textarea":1
        } && this.getValue() == this.oldValue)
{ // Avoid request if no change is made
            this.abort();
            return true;
        }
        
        // if it is empty then the result is nil/empty
            this.isNil = (this.getValue() == "");
        
        
        editor.ajax({
            "type"       : "post",
            "dataType"   : "text",
            "data"       : editor.requestData(),
            "success"    : function(data){
                BestInPlaceCallBack(this);
                editor.loadSuccessCallback(data);
            },
            "error"      : function(request, error){
                editor.loadErrorCallback(request, error);
            }
        });
        if (this.formType == "select") {
            var value = this.getValue();
            $j.each(this.values, function(i, v) {
                if (value == v[0]) {
                    editor.element.html(v[1]);
                }
            }
            );
        } else if (this.formType == "checkbox") {
            editor.element.html(this.getValue() ? this.values[1] : this.values[0]);
        } else {
            editor.element.html(this.getValue());
        }
    },

    activateForm : function() {
        alert("The form was not properly initialized. activateForm is unbound");
    },

    // Helper Functions ////////////////////////////////////////////////////////

    initOptions : function() {
        // Try parent supplied info
        var self = this;
        self.element.parents().each(function(){
            self.url           = self.url           || jQuery(this).attr("data-url");
            self.collection    = self.collection    || jQuery(this).attr("data-collection");
            self.formType      = self.formType      || jQuery(this).attr("data-type");
            self.objectName    = self.objectName    || jQuery(this).attr("data-object");
            self.attributeName = self.attributeName || jQuery(this).attr("data-attribute");
            self.nil           = self.nil           || jQuery(this).attr("data-nil");
        });

        // Try Rails-id based if parents did not explicitly supply something
        self.element.parents().each(function(){
            var res = this.id.match(/^(\w+)_(\d+)$j/i);
            if (res) {
                self.objectName = self.objectName || res[1];
            }
        });

        // Load own attributes (overrides all others)
        self.url           = self.element.attr("data-url")          || self.url      || document.location.pathname;
        self.collection    = self.element.attr("data-collection")   || self.collection;
        self.formType      = self.element.attr("data-type")         || self.formtype || "input";
        self.objectName    = self.element.attr("data-object")       || self.objectName;
        self.attributeName = self.element.attr("data-attribute")    || self.attributeName;
        self.activator     = self.element.attr("data-activator")    || self.element;
        self.nil           = self.element.attr("data-nil")          || self.nil      || "-";

        if (!self.element.attr("data-sanitize")) {
            self.sanitize = true;
        }
        else {
            self.sanitize = (self.element.attr("data-sanitize") == "true");
        }

        if ((self.formType == "select" || self.formType == "checkbox") && self.collection !== null)
        {
            self.values = jQuery.parseJSON(self.collection);
        }
    },

    bindForm : function() {
        this.activateForm = BestInPlaceEditor.forms[this.formType].activateForm;
        this.getValue     = BestInPlaceEditor.forms[this.formType].getValue;
    },

    initNil: function() {
        if (this.element.html() == "")
        {
            this.isNil = true
            this.element.html(this.nil)
        }
    },

    getValue : function() {
        alert("The form was not properly initialized. getValue is unbound");
    },

 // Trim and Strips HTML from text
  sanitizeValue : function(s) {
    if (this.sanitize)
    {
      var tmp = document.createElement("DIV");
      tmp.innerHTML = s;
      s = jQuery.trim(tmp.textContent || tmp.innerText).replace(/"/g, '&quot;');
    }
   return jQuery.trim(s);
  },
  
    /* Generate the data sent in the POST request */
    requestData : function() {
        // To prevent xss attacks, a csrf token must be defined as a meta attribute
        csrf_token = $j('meta[name=csrf-token]').attr('content');
        csrf_param = $j('meta[name=csrf-param]').attr('content');

        var data = "_method=put";
        data += "&" + this.objectName + '[' + this.attributeName + ']=' + encodeURIComponent(this.getValue());

        if (csrf_param !== undefined && csrf_token !== undefined) {
            data += "&" + csrf_param + "=" + encodeURIComponent(csrf_token);
        }
        return data;
    },

    ajax : function(options) {
        options.url = this.url;
        options.beforeSend = function(xhr){
            xhr.setRequestHeader("Accept", "application/json");
        };
        return jQuery.ajax(options);
    },

    // Handlers ////////////////////////////////////////////////////////////////

    loadSuccessCallback : function(data) {
        if (this.element.html() == "")
        {
            this.isNil = true;
            this.element.html(this.nil);
        }
        else
        {
        this.element.html(data[this.objectName]);
        
        }
        
        // Binding back after being clicked
        $j(this.activator).bind('click', {
            editor: this
        }, this.clickHandler);
    },

    loadErrorCallback : function(request, error) {
        this.element.html(this.oldValue);

        // Display all error messages from server side validation
        $j.each(jQuery.parseJSON(request.responseText), function(index, value) {
            var container = $j("<span class='flash-error'></span>").html(value);
            container.purr();
        });

        // Binding back after being clicked
        $j(this.activator).bind('click', {
            editor: this
        }, this.clickHandler);
    },

    clickHandler : function(event) {
        event.data.editor.activate();
    }
};


BestInPlaceEditor.forms = {
    "date" : {
        activateForm : function() {
            var output = '<form class="form_in_place" action="javascript:void(0)" style="display:inline;">';
            output += '<input type="text" value="' + this.sanitizeValue(this.oldValue) + '" class="datepicker" ></form>';
            this.element.html(output);
            this.element.find('input')[0].select();
            this.element.find("form").bind('submit', {
                editor: this
            }, BestInPlaceEditor.forms.input.submitHandler);
            this.element.find("input").bind('blur',   {
                editor: this
            }, BestInPlaceEditor.forms.input.inputBlurHandler);
            this.element.find("input").bind('keyup', {
                editor: this
            }, BestInPlaceEditor.forms.input.keyupHandler);
            //console.log("Date picker begin activated");

            //console.log($j( ".datepicker" ).datepicker());
        },         


        getValue :  function() {
            return this.sanitizeValue(this.element.find("input").val());
        },

        inputBlurHandler : function(event) {
            event.data.editor.update();
        },

        submitHandler : function(event) {
            event.data.editor.update();
        },

        keyupHandler : function(event) {
            if (event.keyCode == 27) {
                event.data.editor.abort();
            }
        }
    },
    "input" : {
        activateForm : function() {
            var output = '<form class="form_in_place" action="javascript:void(0)" style="display:inline;">';
            output += '<input type="text"  class="best_in_place_adj" value="' + this.sanitizeValue(this.oldValue) + '"></form>';
            this.element.html(output);
 //           console.log(this.sanitizeValue(this.oldValue).length );
 //console.log(this.element.find('input'))
 //console.log(getInputSize("40","10",this.element.find('input')));
              //newWidth=((this.sanitizeValue(this.oldValue).length)*8)+5;
//              if (newWidth < 40) newWidth = 40;
              
             // newWidth = getInputSize(5,50,this.element.find('input'))
 
              //this.element.find('input').trigger("focus");
              //this.element.find('input').caretToEnd();
              // console.log(this.element.find('input'));
              //            
              autoGrowInput("",this.element.find('input'));
              
             if (this.element.find('input').width() < 5)  this.element.find('input').width("5");
             
 //console.log(this.element.find('input'))

            this.element.find('input')[0].select();
            this.element.find("form").bind('submit', {
                editor: this
            }, BestInPlaceEditor.forms.input.submitHandler);
            this.element.find("input").bind('blur',   {
                editor: this
            }, BestInPlaceEditor.forms.input.inputBlurHandler);
            this.element.find("input").bind('keyup', {
                editor: this
            }, BestInPlaceEditor.forms.input.keyupHandler);
            this.element.find("input").bind('keydown', {
                editor: this
            }, BestInPlaceEditor.forms.input.keydownHandler);
        },

        getValue :  function() {
            return this.sanitizeValue(this.element.find("input").val());
        },

        inputBlurHandler : function(event) {
            event.data.editor.update();
        },

        submitHandler : function(event) {
            event.data.editor.update();
        },

        keydownHandler : function(event) {
            //autoGrowInput("",this);
            if (event.keyCode == 9) {
                event.preventDefault();
                // window.alert("keydown: " + event.keyCode);
                //  $j(this).parent().next().next().find(".best_in_place").trigger('click');
                //    $j(this).parent().parent().parent().next().next().find(".best_in_place").trigger('click');
               list=$j(".best_in_place");
               thisID=jQuery.inArray($j(this).parent().parent()[0],list);
               
              
                if (event.shiftKey )
                {
                   // eval("$j(this).parent().parent().parent().prev().prev().prev().find('.best_in_place').trigger('click')")
                  //  console.log($j(this).parent().parent().parent().prev().prev().prev().find(".best_in_place").trigger('click'));
                    //console.log($j(this).parent().parent().parent().prev().prev().find(".best_in_place").trigger('click'));
                // the wait function is a fix for a bug with safari
                    $j(this).focus();
                     wait(10);
                    $j(this).caretToEnd();
                    wait(10);
                    $j(list[thisID-1]).trigger('click');
                }
                else
                {
                //    console.log($j(this).parent().parent());
                 //   console.log($j(list[0]));
                  // console.log( thisID=jQuery.inArray($j(this).parent().parent()[0],list)+1)
                  //  console.log($j(list[thisID]).trigger('click'));
                  // console.log($j(this));
                     $j(this).focus();
                     wait(10);
                    $j(this).caretToEnd();
                    wait(10);
                    $j(list[thisID+1]).trigger('click');
                    wait(10);
     //               console.log($j(this).parent().parent().parent().next().next().next().find(".best_in_place").trigger('click'));
     //               console.log( $j(this).parent().parent().parent().next().next().find(".best_in_place").trigger('click'));

                }
                   
            //   $j(this).next('.best_in_place').activate();

            }

        },

        keyupHandler : function(event) {
            //autoGrowInput("",this);
            if (event.keyCode == 27) {
                event.data.editor.abort();
            }
        }
    },

    "select" : {
        activateForm : function() {
            var output = "<form action='javascript:void(0)' style='display:inline;'><select>";
            var selected = "";
            var oldValue = this.oldValue;
            $j.each(this.values, function(index, value) {
                selected = (value[1] == oldValue ? "selected='selected'" : "");
                output += "<option value='" + value[0] + "' " + selected + ">" + value[1] + "</option>";
            });
            output += "</select></form>";
            this.element.html(output);
            this.element.find("select").bind('change', {
                editor: this
            }, BestInPlaceEditor.forms.select.blurHandler);
            this.element.find("select").bind('blur', {
                editor: this
            }, BestInPlaceEditor.forms.select.blurHandler);
            this.element.find("select").bind('keyup', {
                editor: this
            }, BestInPlaceEditor.forms.select.keyupHandler);
            this.element.find("select")[0].focus();
        },

        getValue : function() {
            return this.sanitizeValue(this.element.find("select").val());
        },

        blurHandler : function(event) {
            event.data.editor.update();
        },
    

        keyupHandler : function(event) {
            if (event.keyCode == 27) 
            {
                event.data.editor.abort();
            }
        }
    },

    "checkbox" : {
        activateForm : function() {
            var newValue = Boolean(this.oldValue != this.values[1]);
            var output = newValue ? this.values[1] : this.values[0];
            this.element.html(output);
            this.update();
        },

        getValue : function() {
            return Boolean(this.element.html() == this.values[1]);
        }
    },

    "textarea" : {
        activateForm : function() {
            // grab width and height of text
            width = this.element.css('width');
            height = this.element.css('height');

            // construct the form
            var output = '<form action="javascript:void(0)" style="display:inline;"><textarea>';
            output += this.sanitizeValue(this.oldValue);
            output += '</textarea></form>';
            this.element.html(output);

            // set width and height of textarea
            jQuery(this.element.find("textarea")[0]).css({
                'min-width': width, 
                'min-height': height
            });
            jQuery(this.element.find("textarea")[0]).elastic();

            this.element.find("textarea")[0].focus();
            this.element.find("textarea").bind('blur', {
                editor: this
            }, BestInPlaceEditor.forms.textarea.blurHandler);
            this.element.find("textarea").bind('keyup', {
                editor: this
            }, BestInPlaceEditor.forms.textarea.keyupHandler);
        },

        getValue :  function() {
            return this.sanitizeValue(this.element.find("textarea").val());
        },

        blurHandler : function(event) {
            event.data.editor.update();
        },

        keyupHandler : function(event) {
            if (event.keyCode == 27) {
                BestInPlaceEditor.forms.textarea.abort(event.data.editor);
            }
        },

        abort : function(editor) {
            if (confirm("Are you sure you want to discard your changes?")) {
                editor.abort();
            }
        }
    }
};

jQuery.fn.best_in_place = function() {
    this.each(function(){
        jQuery(this).data('bestInPlaceEditor', new BestInPlaceEditor(this));
    });
    return this;
};



/**
*	@name							Elastic
*	@descripton						Elastic is Jquery plugin that grow and shrink your textareas automaticliy
*	@version						1.6.5
*	@requires						Jquery 1.2.6+
*
*	@author							Jan Jarfalk
*	@author-email					jan.jarfalk@unwrongest.com
*	@author-website					http://www.unwrongest.com
*
*	@licens							MIT License - http://www.opensource.org/licenses/mit-license.php
*/

(function(jQuery){
    jQuery.fn.extend({
        elastic: function() {
            //	We will create a div clone of the textarea
            //	by copying these attributes from the textarea to the div.
            var mimics = [
            'paddingTop',
            'paddingRight',
            'paddingBottom',
            'paddingLeft',
            'fontSize',
            'lineHeight',
            'fontFamily',
            'width',
            'fontWeight'];

            return this.each( function() {

                // Elastic only works on textareas
                if ( this.type != 'textarea' ) {
                    return false;
                }

                var $jtextarea	=	jQuery(this),
                $jtwin		=	jQuery('<div />').css({
                    'position': 'absolute',
                    'display':'none',
                    'word-wrap':'break-word'
                }),
                lineHeight	=	parseInt($jtextarea.css('line-height'),10) || parseInt($jtextarea.css('font-size'),'10'),
                minheight	=	parseInt($jtextarea.css('height'),10) || lineHeight*3,
                maxheight	=	parseInt($jtextarea.css('max-height'),10) || Number.MAX_VALUE,
                goalheight	=	0,
                i 			=	0;

                // Opera returns max-height of -1 if not set
                if (maxheight < 0) {
                    maxheight = Number.MAX_VALUE;
                }

                // Append the twin to the DOM
                // We are going to meassure the height of this, not the textarea.
                $jtwin.appendTo($jtextarea.parent());

                // Copy the essential styles (mimics) from the textarea to the twin
                var i = mimics.length;
                while(i--){
                    $jtwin.css(mimics[i].toString(),$jtextarea.css(mimics[i].toString()));
                }


                // Sets a given height and overflow state on the textarea
                function setHeightAndOverflow(height, overflow){
                    curratedHeight = Math.floor(parseInt(height,10));
                    if($jtextarea.height() != curratedHeight){
                        $jtextarea.css({
                            'height': curratedHeight + 'px',
                            'overflow':overflow
                        });

                    }
                }


                // This function will update the height of the textarea if necessary
                function update() {

                    // Get curated content from the textarea.
                    var textareaContent = $jtextarea.val().replace(/&/g,'&amp;').replace(/  /g, '&nbsp;').replace(/<|>/g, '&gt;').replace(/\n/g, '<br />');

                    // Compare curated content with curated twin.
                    var twinContent = $jtwin.html().replace(/<br>/ig,'<br />');

                    if(textareaContent+'&nbsp;' != twinContent){

                        // Add an extra white space so new rows are added when you are at the end of a row.
                        $jtwin.html(textareaContent+'&nbsp;');

                        // Change textarea height if twin plus the height of one line differs more than 3 pixel from textarea height
                        if(Math.abs($jtwin.height() + lineHeight - $jtextarea.height()) > 3){

                            var goalheight = $jtwin.height()+lineHeight;
                            if(goalheight >= maxheight) {
                                setHeightAndOverflow(maxheight,'auto');
                            } else if(goalheight <= minheight) {
                                setHeightAndOverflow(minheight,'hidden');
                            } else {
                                setHeightAndOverflow(goalheight,'hidden');
                            }

                        }

                    }

                }

                // Hide scrollbars
                $jtextarea.css({
                    'overflow':'hidden'
                });

                // Update textarea size on keyup, change, cut and paste
                $jtextarea.bind('keyup change cut paste', function(){
                    update();
                });

                // Compact textarea on blur
                // Lets animate this....
                $jtextarea.bind('blur',function(){
                    if($jtwin.height() < maxheight){
                        if($jtwin.height() > minheight) {
                            $jtextarea.height($jtwin.height());
                        } else {
                            $jtextarea.height(minheight);
                        }
                    }
                });

                // And this line is to catch the browser paste event
                $jtextarea.live('input paste',function(e){
                    setTimeout( update, 250);
                });

                // Run update once when elastic is initialized
                update();

            });

        }
    });
})(jQuery);
