(function($, window, document, navigator, global) {
    var spider = spider ? spider : {
      settings: {
      	init: function(){
      		// Initializing our JS Library Settings
          spider.search.init();
      	}
      },
      search: {
        init: function(){
          $('body.v1 input#search_bar').off('keyup change').on('keyup change', function(){
            $.getJSON('/api/v1/species/search.json?q='+$(this).val(),{async: true}, function(yield){
              setTimeout(function(){
                spider.search.updateResults(yield);
              },0);
            });
          });
        },
        updateResults: function(json){
          $resultCount = $('body.v1 span#result_count');
          $results = $('body.v1 div#results div.row');
          $results.html('');
          $resultCount.html(json.length);
          $.each(json, function(){
            imageSrc = "/images/spider-id-logo.png"
            commonName = this.common_name || this.scientific_name
            scientificName = this.scientific_name
            characteristics = this.characteristics
            $results.append('\
              <div class="span6 card">\
                <img alt="Spider id logo" src="'+imageSrc+'">\
                <div class="left">\
                  <span class="common_name">'+commonName+'</span><br>\
                  <span class="scientific_name">'+scientificName+'</span><br>\
                  <span class="characteristics"><strong>Characteristics:</strong> '+characteristics+'</span>\
                </div>\
              </div>\
            ');
          });
        }
      },
      init: function(){
      	spider.settings.init();
      },
      toggleElement: function(element_class){
      	$(element_class).slideToggle(250);
      }
    };
    global.spider = spider;
})(jQuery, window, document, navigator, this);

jQuery(function($){
	$(document).ready(function(){
		spider.init();
	});
});
