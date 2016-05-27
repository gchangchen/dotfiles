unmap('<Ctrl-i>');
unmap('u');
unmap('g$');
unmap('R');
mapkey('R', '#4Reload the page without cache', 'RUNTIME("reloadTab", { nocache: true })');
unmap('[[');
unmap(']]');
mapkey('[[', '#1Click on the previous link on current page', function() {
	var prevLinks = $('a').regex(/((<<|prev(ious)?|上一页)+)/i);
	if (prevLinks.length) {
		clickOn(prevLinks);
	} else {
		walkPageUrl(-1);
	}
});
mapkey(']]', '#1Click on the next link on current page', function() {
	var nextLinks = $('a').regex(/((>>|next|下一页)+)/i);
	if (nextLinks.length) {
		clickOn(nextLinks);
	} else {
		walkPageUrl(1);
	}
});
mapkey('gt', '#3Go one tab right', 'RUNTIME("nextTab")');
map('p', 'cc');

mapkey('g+', '#4Go path +1 in the URL', function() {
	var pathname = location.pathname;
	if (pathname.length > 1) {
		var num_match = pathname.match(/\d+/);
		if(num_match){
			var num = parseInt(num_match);
			if(num >= 0){
				pathname = pathname.replace(num_match, num+1);
			}
		}
	}
	window.location.pathname = pathname;
});
mapkey('g_', '#4Go path -1 in the URL', function() {
	var pathname = location.pathname;
	if (pathname.length > 1) {
		var num_match = pathname.match(/\d+/);
		if(num_match){
			var num = parseInt(num_match);
			if(num > 0){
				pathname = pathname.replace(num_match, num-1);
			}
		}
	}
	window.location.pathname = pathname;
});

