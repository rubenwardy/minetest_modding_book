// @license magnet:?xt=urn:btih:90dc5c0be029de84e523b9b3922520e79e0e6f08&dn=cc0.txt CC0
// This script is licensed under CC0

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

// @license-end
