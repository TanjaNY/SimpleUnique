var express = require('express');
var app = express();

var path = __dirname + '/client/views/';
var bootstrap   =  __dirname + '/client/bootstrap-3.3.5-dist/';
var contractdir = __dirname + '/build/contracts/';

app.get('/', (req,res) => {
	res.sendFile(path+'index.html');
});


//app.use(express.static('js', bootstrap + 'js'));
app.use('/js',express.static(bootstrap + 'js' ));
app.use('/fonts',express.static(bootstrap + 'fonts' ));
app.use('/css',express.static(bootstrap + 'css' ));
app.use('/contract',express.static(contractdir));
app.use('/js2',express.static(path));



app.listen(4000, () => {
	console.log('lauscht 4000');
});
