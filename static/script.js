$(function() {
	$("#printable").click(function() {
		$("body").addClass("printable");
	});

	return $("h2, h3, h4, h5, h6").each(function(i, el) {
		var $el, icon, id;
		$el = $(el);
		id = $el.attr('id');
		if (id) {
			return $el.prepend($("<a />").addClass("header-link").attr("href", "#" + id).html("#"));
		}
	});
});
