
function filterable_table(options) {
	this.table = $(options.selector);
	this.cookie_name = options.cookie_name;
	this.columns = options.columns;
	this.modal = options.modal;
	this.anchor = options.anchor;
	this.filter_container = options.filter_container;
	this.cancel = $(options.cancel);
	this.okay = $(options.okay);

	this.children = [];

	this.setup_html();

	for( k in this.columns ) {
		this.children.push( new cookied_filter(k, this.columns[k], this) );
	}

	this.children.push( new cookied_filter("layout", false, this, {
		type: "extra",
		label: "Use striped layout for descriptions"
	}));

	this.cancel.click( function() {	});
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

// ===========================================================================
// atomic cookie -- ex: insights_column_slug, insights_columns_editor
// ===========================================================================

function cookied_filter( name, value, parent, options) {
	this.name = name;
	this.column_name = ".column_" + name;
	this.cookie_name = parent.cookie_name + "_" + name;
	this.options = options;

	this.value = value;

	this.parent = parent;

	this.setup_html();
	this.load();
}

cookied_filter.prototype.act_column = function() {

	this.checkbox[0].checked = this.value;

	if( this.value == true ) {
		$(this.column_name).show();
	} else {
		$(this.column_name).hide();
	}

	this.fix_colspan();
}

cookied_filter.prototype.act_extra = function() {

	this.checkbox[0].checked = this.value;
	if( this.value != true ) return(false);

	this.setup_striped_rows();
	this.fix_even_odd_rows();

	var that = this;
	$(this.parent.table).on("before-sort", function(e) {
		that.destroy_striped_rows();
	}).on("sorted", function() {
		that.setup_striped_rows();
		that.fix_even_odd_rows();
	});
}

cookied_filter.prototype.fix_even_odd_rows = function() {
	var trs = $("tbody tr", this.parent.table);

	trs.removeClass("striped-even striped-odd");
	trs.each( function(i,e) {
		if( parseInt(i/2) % 2 ) {
			$(e).addClass("striped-odd");
		} else {
			$(e).addClass("striped-even");
		}
	});
}


// rudimentary support for striped rows:
// deconstruct before sorting, construct after sorting
cookied_filter.prototype.setup_striped_rows = function() {
	$(".column_description").hide();



	$("tr.insights_entry").each( function(i,e) {
		var descr = $(".column_description", e).html();
		$(e).after(
			"<tr class='striped_tr'>" +
			"<td class='striped_td striped_td_left entry_field column_description'>" +
			descr +
			"</td><td class='striped_td striped_td_right'></td></tr>"
		);
	});

	this.fix_colspan();
}

cookied_filter.prototype.fix_colspan = function() {
	var visible_columns = $("thead th:visible", this.parent.table).length;
	$(".striped_td_left", this.parent.table).each( function(i,e) {
		$(e).attr("colspan", visible_columns - 1);
	});
}

cookied_filter.prototype.destroy_striped_rows = function() {
	$("tr.striped_tr").remove();
}

cookied_filter.prototype.is_extra = function() {
	if(
		(typeof this.options != "undefined") &&
		(typeof this.options.type != "undefined") &&
		(this.options.type == "extra")
	) {
		return(true);
	} else {
		return(false);
	}
}

cookied_filter.prototype.act = function() {
	if( this.is_extra() == true ) {
		this.act_extra();
	} else {
		this.act_column();
	}
}

// delete cookie, set visible
cookied_filter.prototype.reset = function() {
	this.value = true;
	this.act();
	this.save();
}

cookied_filter.prototype.click = function() {
	this.value = this.checkbox[0].checked;
	this.act();
	this.save();
}

cookied_filter.prototype.setup_column = function() {
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

cookied_filter.prototype.setup_extra = function() {
	var id = "id_cookied_filter_" + this.name;
	var ul = $("#filterModal_extra_ul");
	var li = $("<li></li>");
	var label = $("<label for='" + id + "'> " + this.options.label + "</label>");
	var checkbox = $(
		"<input style='margin-right:7px' id='" + id +
		"' type='checkbox' name='filter_column' value=''" +
		this.name + "'/>"
	);

	var that = this;

	//checkbox.prop("checked", this.value);
	checkbox.on("click", function() {
		that.click();
	});

	li.append( checkbox );
	li.append( label );
	ul.append( li );

	this.checkbox = checkbox;
}

// <ul><li><checkbox /><label></label></li></ul>
cookied_filter.prototype.setup_html = function() {

	if( this.is_extra() == true ) {
		this.setup_extra();
	} else {
		this.setup_column();
	}
}

cookied_filter.prototype.load = function() {
	this.act();

	var cookie = $.cookie(this.cookie_name);

	if( typeof cookie != "undefined" ) {
		if( cookie == "show" ) this.value = true;
		if( cookie == "hide" ) this.value = false;
		this.act();
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
