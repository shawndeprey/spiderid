(function($, window, document, navigator, global) {
    var spider = spider ? spider : {
      settings: {
      	init: function(){
      		// Initializing our JS Library Settings
      	}
      },
      init: function(){
      	spider.settings.init();
      },
      toggleElement: function(element_class){
      	$("."+element_class).slideToggle(250);
      }
    };
    global.spider = spider;
})(jQuery, window, document, navigator, this);

jQuery(function($){
	$(document).ready(function(){
		spider.init();
	});
});
