
function filterable_table(options) { }

filterable_table.prototype.init = function(options) {
	this.table = $(options.selector);
	this.cookie_name = options.cookie_name;
	this.columns = options.columns;
	this.modal = options.modal;
	this.anchor = options.anchor;
	this.filter_container = options.filter_container;
	this.cancel = $(options.cancel);
	this.okay = $(options.okay);
	this.children = {};

	this.setup_html();
	this.cancel.click( function() {	});

	for( k in this.columns ) {
		this.children[k] = new cookied_filter().init(
			k, this.columns[k], this
		);
	}

	this.children["striped_layout"] = new cookied_filter_striped().init(
		"layout", true, this, {
			label: "Use striped layout for descriptions"
		}
	);

	// dependency
	this.children["description"].Connect(this.children["striped_layout"]);

	// bugfix?
	//this.children["description"].Apply();
}

filterable_table.prototype.reset_all = function() {
	for( k in this.children ) {
		this.children[k].reset();
	}
}

filterable_table.prototype.setup_html = function() {
	var a = $("<a title='Choose columns to show/hide, and other display options' href='#'>Customize</a>");
	var div = $("<div class='filterable_table_trigger pull-right'></div>");

	$("#filterModal_button_reset").click( function() {
		parent.reset_all();
	});

	var parent = this;
	a.click(function() {
		$(parent.modal).modal("show");
		return( false );
	});

	$(div).append(a);
	$(this.anchor).append(div);
}

filterable_table.prototype.fix_colspan = function() {
	var visible_columns = $("thead th:visible", this.table).length;
	$(".striped_td_left", this.table).each( function(i,e) {
		$(e).attr("colspan", visible_columns - 1);
	});
}

// ===========================================================================
// atomic cookie -- ex: insights_column_slug, insights_columns_editor
// ===========================================================================

function cookied_filter() { }

// allows mixing of other init values
cookied_filter.prototype.default_values = function() { }

// setup_html() -> load() -> Apply()
cookied_filter.prototype.init = function( name, value, parent, options) {
	this.default_values();

	this.name = name;
	this.column_name = ".column_" + name;
	this.cookie_name = parent.cookie_name + "_" + name;
	this.options = options;

	this.click_event = null;  // dependency click

	this.value = value;
	this.parent = parent;

	this.setup_html();
	this.load();
	this.Apply();

	return( this );
}

cookied_filter.prototype.Connect = function(rec) {
	this.click_event = rec;
}

cookied_filter.prototype.Apply = function() {
	if( this.click_event != null ) {
		this.click_event.Apply(true);
	}

	this.checkbox[0].checked = this.value;

	if( this.click_event == null || this.click_event.value == false ) {
		if( this.value == true ) {
			$(this.column_name).show();
		} else {
			$(this.column_name).hide();
		}
	}

	this.parent.fix_colspan();
}

// delete cookie, set visible
cookied_filter.prototype.reset = function() {
	this.value = true;
	this.Apply();
	this.save();
}

// click event, from jquery
cookied_filter.prototype.click = function() {
	this.value = this.checkbox[0].checked;
	this.Apply();
	this.save();
}

// <ul><li><checkbox /><label></label></li></ul>
cookied_filter.prototype.setup_html = function() {
	var id = "id_cookied_filter_" + this.name;
	var ul = $(this.parent.filter_container);
	var li = $("<li></li>");
	var label = $("<label for='" + id + "'> " + this.name + "</label>");
	var checkbox = $(
		"<input style='margin-right:7px' id='" + id +
		"' type='checkbox' name='filter_column' value=''" +
		this.name + "'/>"
	);

	var that = this;

	checkbox.on("click", function() {
		that.click();
	});

	li.append( checkbox );
	li.append( label );
	ul.append( li );

	this.checkbox = checkbox;
}

cookied_filter.prototype.load = function() {
	var cookie = $.cookie(this.cookie_name);

	if( typeof cookie != "undefined" ) {
		if( cookie == "show" ) this.value = true;
		if( cookie == "hide" ) this.value = false;
	} else {
		this.checkbox[0].checked = this.value;
	}
}

cookied_filter.prototype.save = function() {
	$.cookie(this.cookie_name, this.value ? 'show' : 'hide', {
		expires: 365,
		path: '/'
	});
}

// ===========================================================================
// special type of cookie, for striped layouts
// ===========================================================================

function cookied_filter_striped() { }

cookied_filter_striped.prototype = Object.create(cookied_filter.prototype);

cookied_filter_striped.prototype.default_values = function() {
	this.rows_setup = false;
}

cookied_filter_striped.prototype.Apply = function(connected_event) {
	// a dependency might need to be solved
	if( typeof connected_event != "undefined" && connected_event == true ) {
		if( this.value == true ) {
			$(".column_description").hide();
		}
	}

	this.checkbox[0].checked = this.value;
	if( this.value == true ) {
		this.setup_striped_rows();
		this.fix_even_odd_rows();
	} else {
		this.destroy_striped_rows();
		this.fix_even_odd_rows();
		this.WriteNote("");
		return(false);
	}

	var that = this;
	$(this.parent.table).on("before-sort", function(e) {
		that.destroy_striped_rows();
	}).on("sorted", function() {
		that.setup_striped_rows();
		that.fix_even_odd_rows();
	});
}
cookied_filter_striped.prototype.reset = function() {
	this.destroy_striped_rows();

	this.value = true;
	this.setup_striped_rows();
	this.fix_even_odd_rows();
}

cookied_filter_striped.prototype.destroy_striped_rows = function() {

	if( this.rows_setup == false ) return(false);

	if( this.parent.children["description"].value == true ) {
		$(this.parent.children["description"].column_name).show();
	}

	$("tr.striped_tr").remove();
	this.rows_setup = false;
}

// rudimentary support for striped rows:
// deconstruct before sorting, construct after sorting
cookied_filter_striped.prototype.setup_striped_rows = function() {

	if( this.parent.children["description"].value == false ) {

		this.WriteNote(
			"Note: this feature only works if the description field is visible. " +
			"To make it work, please click on the description checkbox to the left"
		);

		// can't do striped rows if the description column is hidden
		this.destroy_striped_rows();
		return(false);
	} else {
		this.WriteNote("");
	}

	if( this.rows_setup == true ) return(false);

	$(".column_description").hide();

	$("tr.insights_entry").each( function(i,e) {
		var preserve_class = $(e).data("preserve-class");
		var descr = $(".column_description", e).html();
		$(e).after(
			"<tr class='striped_tr " + preserve_class + "'>" +
			"<td class='striped_td striped_td_left entry_field column_description highlightable'>" +
			descr +
			"</td><td class='striped_td striped_td_right'></td></tr>"
		);
	});

	this.rows_setup = true;
	this.parent.fix_colspan();
}

cookied_filter_striped.prototype.fix_even_odd_rows = function() {
	var trs = $("tbody tr", this.parent.table);
	trs.removeClass("striped-even striped-odd");

	if( this.rows_setup == false ) {
		return( false );
	}

	trs.each( function(i,e) {
		if( parseInt(i/2) % 2 ) {
			$(e).addClass("striped-odd");
		} else {
			$(e).addClass("striped-even");
		}
	});
}

cookied_filter_striped.prototype.WriteNote = function(msg) {
	var that = this;

	this.note.stop().animate({ opacity: 0 }, function() {
		that.note.html(msg);
		that.note.animate({ opacity: 1 });
	});
}

cookied_filter_striped.prototype.setup_html = function() {
	var id = "id_cookied_filter_" + this.name;
	var ul = $("#filterModal_extra_ul");
	var li = $("<li></li>");
	var label = $("<label for='" + id + "'> " + this.options.label + "</label>");
	var checkbox = $(
		"<input style='margin-right:7px' id='" + id +
		"' type='checkbox' name='filter_column' value=''" +
		this.name + "'/>"
	);

	var note = $("<div class='cookie_option_note'></div>");

	var that = this;

	//checkbox.prop("checked", this.value);
	checkbox.on("click", function() {
		that.click();
	});

	this.note = note;

	li.append( checkbox );
	li.append( label );
	li.append( note );
	ul.append( li );

	this.checkbox = checkbox;
}
