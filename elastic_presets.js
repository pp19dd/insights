/*
	turns node elements into cookied presets

	required:
		jquery / $.cookie
		node elements must have an id
		ace.io editor
	example usage:
		$(".myclass").esPreset({
			destination: editor,
			default_code: default_code
		});
*/
(function($) {

	var presets = [];
	var cookie_prefix = "elasticsearch_admin_preset_";
	var editor;

	function get_active_preset() {
		var active = $(presets).filter(".active-preset");
		var id = $(active).attr("id");
		return( id );
	}

	function startup() {
		var active = $.cookie(cookie_prefix + "selected");
		if( typeof active == "undefined" ) {
			active = ["preset_a"];
			save_preset(active, default_code);
		}
		load_preset(active);
		set_active_preset(active);

		editor.on("change", function(e) {
			save_preset(get_active_preset(), editor.getValue());
		});
	}

	function save_preset(id, text) {
		$.cookie(cookie_prefix + id, text );
	}

	function load_preset(id) {
		var text = $.cookie(cookie_prefix + id);
		if( typeof text == "undefined") text = "";
		editor.setValue(text);
	}

	// marks selected preset, cookies it
	function set_active_preset(id) {
		$.cookie(cookie_prefix + "selected", id);
		$(presets).removeClass("active-preset");
		$(presets).filter("#" + id).addClass("active-preset");
	}

	function do_click(x) {
		var active = get_active_preset();
		save_preset( active, editor.getValue() );

		var id = $(x).attr("id");

		set_active_preset(id);
		load_preset(id);
	}

	$.fn.esPreset = function(init) {
		editor = init.destination;
		default_code = init.default_code;

		this.each( function() {
			$(this).click(function() {
				do_click(this);
			});
			presets.push(this);
		});

		startup();
	}
}(jQuery));
