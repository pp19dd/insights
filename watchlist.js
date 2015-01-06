// ===========================================================================
// watchlist
// ===========================================================================

function watchlist() { }

watchlist.prototype.init = function() {
	this.cookie_name = "insights_watch_list";
	this.ids_object = { };
	var t = $.cookie(this.cookie_name);

	if( typeof t == "undefined") {
		t = "";
		this.save();
	}

	this.load_values(t);
	this.setup_html();
}

watchlist.prototype.get_count = function() {
	var temp = this.getList();
	return( temp.length );
}

watchlist.prototype.update_count = function() {
	$(".insights_watchlist_count").html( this.get_count() );
}

watchlist.prototype.checked = function(id) {
	if( typeof this.ids_object[id] == "undefined" ) {
		return("");
	} else {
		return(" checked='checked'");
	}
}

watchlist.prototype.clear = function(id) {
	for( var k in this.ids_object ) {
		$("#watch_" + k).prop("checked", false);
	}
	this.ids_object = { };
	this.save();
}

watchlist.prototype.utility_links = function() {
	var that = this;
	$(".watchlist_clear_link").click(function(e){
		that.clear();
		e.preventDefault();
	});
	$(".watchlist_share_link").click(function(e){
		e.preventDefault();
	});
}

watchlist.prototype.setup_html = function() {
	this.update_count();
	this.utility_links();
	var that = this;

	$("tbody .column_action").each(function(i,e) {
		var button_id = $(this).attr("data-id");
		var watch_id = "watch_" + button_id;

		var checkbox = $(
			"<input id='" + watch_id + "'" +
			that.checked(button_id) +
			"type='checkbox' />"
		);

		var label = $("<label for='" + watch_id + "'>&nbsp;Watch</label>");

		$(checkbox).change(function() {
			var state = $(this).prop("checked");

			if( state == false ) {
				that.remove(button_id);
			} else {
				that.add(button_id);
			}
		});

		$(this).append(checkbox);
		$(this).append(label);

		/*$(e).mouseover(function() {
			$(checkbox).show();
			$(label).show();
		}).mouseout(function() {
			$(checkbox).hide();
			$(label).hide();
		});*/
	});

}

watchlist.prototype.load_values = function(t) {
	var a = t.split(",");

	for( var i = 0; i < a.length; i++ ) {
		if( a[i].length == 0 ) continue;

		var key = parseInt(a[i]);
		this.add(key);
	}
}

watchlist.prototype.save = function() {
	$.cookie(this.cookie_name, this.list(), {
		expires: 365,
		path: '/'
	});
	this.update_count();
}

watchlist.prototype.add = function(id) {
	this.ids_object[id] = true;
	this.save();
}

watchlist.prototype.remove = function(id) {
	delete( this.ids_object[id] );
	this.save();
}

watchlist.prototype.getList = function() {
	var output = [];
	for( var k in this.ids_object ) {
		output.push( k );
	}
	return( output );
}

watchlist.prototype.list = function() {
	return( this.getList().join(",") );
}
