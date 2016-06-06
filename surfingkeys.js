unmap('<Ctrl-i>');
unmap('u');

mapkey('gr', '#4Reload the page without cache', 'RUNTIME("reloadTab", { nocache: true })');

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

addSearchAliasX('t', 'translates', 'https://translate.google.com/#en/zh-CN/', 's',
		'https://clients1.google.com/complete/search?client=translate_separate_corpus&ds=translate&hl=en&requiredfields=tl%3Azh-CN&q=',
		function(response){
			var res = response.text.match(/\[\[.*\]\]/);
			res = eval(res[0]);
			for(var i=0; i<res.length; i++){
				res[i]=res[i][0];
			}
			Omnibar.listWords(res);
		});
mapkey('ot', '#8Open Search with alias t', 'Normal.openOmnibar({type: "SearchEngine", extra: "t"})');

mapkey('I', '#1Edit textarea with Vim', function() {
	Hints.create("input:visible, textarea:visible", 
			function (element, event) { 
				if (element.localName === "textarea" || (element.localName === "input" &&
							/^(?!button|checkbox|file|hidden|image|radio|reset|submit)/i.test(element.type)) || 
						element.hasAttribute("contenteditable")) {
					function onMessage(event){
						element.value = event.data.message;
						element.focus();
						window.removeEventListener('message', onMessage, false);
					}
					window.addEventListener('message', onMessage, false);
					function onEditorWrite(url){
						return new Function('data', "window.parent.postMessage({message: data},\"{0}\");".format(url));
					}
					Normal.showEditor(element.value, onEditorWrite(window.location.href));
				}
			});
});

mapkey('gQ', '#1QR for current URL', function(){
	Normal.getContentFromClipboard(function(response) {
		data = response.data ? response.data : window.location.href;
		data = data.replace(/&/g, '%26');
		data = data.replace(/\n/g, '%0A');
		Normal.showPopup('<img src="http://qr.topscan.com/api.php?text=' + data + '"/>');
	});
});
mapkey('gq', '#1QR for clipboard', function(){
	data = window.location.href;
	data = data.replace(/&/g, '%26');
	data = data.replace(/\n/g, '%0A');
	Normal.showPopup('<img src="http://qr.topscan.com/api.php?text=' + data + '"/>');
});

