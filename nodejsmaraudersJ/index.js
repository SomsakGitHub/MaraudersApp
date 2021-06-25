const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');

const hostname = '127.0.0.1';
const port = 8080;

//Create express app.
const app = express();

//Database
mongoose.connect('mongodb+srv://somsak:john.terry26@maraudersapp.2ccqa.mongodb.net/marauders?retryWrites=true&w=majority', {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

const db = mongoose.connection;

db.once('open', () => {
  console.log("DB connection");
});

//Middleware
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());

//Routes
app.get('/', (req, res) => {
  res.send('Hello marauders app.');
});

const UserRoute = require('./routes/User');
const TimeLineRoute = require('./routes/TimeLine');

app.use('/user', UserRoute)
app.use('/timeLine', TimeLineRoute)

//Strating server.
app.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});