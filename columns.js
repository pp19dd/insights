
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

	this.cancel.click( function() {	});
}

filterable_table.prototype.reset_all = function() {
	for( k in this.children ) {
		this.children[k].reset();
	}
}

filterable_table.prototype.setup_html = function() {
	var a = $("<a title='Choose columns to show/hide' href='#'>Columns</a>");
	var r = $("<a title='Reset columns' href='#'>Reset</a>");
	var div = $("<div class='filterable_table_trigger pull-right'></div>");

	var parent = this;
	a.click(function() {
		$(parent.modal).modal("show");
		return( false );
	});

	r.click( function() {
		$(parent.reset_all());
		r.addClass("filter_reset");
		return( false );
	});

	$(div).append(a).append("<span> | </span>").append( r );

	$(this.anchor).append(div);
}

function cookied_filter( name, value, parent ) {
	this.name = name;
	this.column_name = ".column_" + name;
	this.cookie_name = parent.cookie_name + "_" + name;

	this.value = value;

	this.parent = parent;

	this.setup_html();
	this.load();
}

cookied_filter.prototype.act = function() {

	this.checkbox[0].checked = this.value;

	if( this.value == true ) {
		$(this.column_name).show();
	} else {
		$(this.column_name).hide();
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

// <ul><li><checkbox /><label></label></li></ul>
cookied_filter.prototype.setup_html = function() {

	var id = "id_cookied_filter_" + this.name;
	var ul = $(this.parent.filter_container);
	var li = $("<li></li>");
	var label = $("<label for='" + id + "'> " + this.name + "</label>");
	var checkbox = $(
		"<input style='margin-right:7px' id='" + id +
		"' type='checkbox' name='filter_column' value=" +
		this.name + "'/>"
	);

	var that = this;

	checkbox.click( function() { that.click(); });

	li.append( checkbox );
	li.append( label );
	ul.append( li );

	this.checkbox = checkbox;
}

cookied_filter.prototype.load = function() {
	this.act();

	var cookie = $.cookie(this.cookie_name);

	if( typeof cookie != "undefined" ) {
		if( cookie == "show" ) this.value = true;
		if( cookie == "hide" ) this.value = false;
		this.act();
	} else {
		this.checkbox[0].checked = true;
	}
}

cookied_filter.prototype.save = function() {
	$.cookie(this.cookie_name, this.value ? 'show' : 'hide', {
		expires: 365,
		path: '/'
	});
}
