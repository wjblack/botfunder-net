document.addEventListener('DOMContentLoaded', () => {
	var p = new Ping();
	p.ping("https://wjblack.com", function(err, data) {
		data = data + " " + err;
		console.log(data);
	});
});
