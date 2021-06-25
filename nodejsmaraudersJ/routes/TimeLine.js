const express = require('express');
var multer  = require('multer');
var fs = require('fs');
const router = express.Router();
var upload = multer({ dest: 'uploads/' });
const TimeLine = require('../models/TimeLine');

//Get all routes.
router.get('/:latitude&:longitude', async (req, res) => {

  try {

    // console.log("latitude", parseFloat(req.params.latitude))
    // console.log("longitude", parseFloat(req.params.longitude))

    const timeLine = await TimeLine.find();

    var data = []

    for (const type of timeLine) {  
      
      let d = getDistanceFromLatLonInKm(
        parseFloat(req.params.latitude),
        parseFloat(req.params.longitude),
        type.latitude,
        type.longitude
      ) 

      if (d < 1) {
        data.push(type)
      }
    }

    res.status(200).json(data);
  } catch (error) {
    res.status(400).json({ msg: error });
  }
})

//Create new timeLine.
router.post('/create', upload.single('image'), async (req, res) => {  

    try {

      const newTimeLine = new TimeLine(req.body);
      var base64str = base64_encode(req.file.path);
      newTimeLine.image = base64str;

      const saveTimeLine = await newTimeLine.save();
  
      res.status(200).json(saveTimeLine);
    } catch (error) {
      res.status(400).json({ msg: error });
    }
  });

// function to encode file data to base64 encoded string
function base64_encode(file) {

  let buff = fs.readFileSync(file);
  let base64data = buff.toString('base64');

  return base64data

    // // read binary data
    // var bitmap = fs.readFileSync(file);
    // // convert binary data to base64 encoded string
    // return new Buffer.from(bitmap).toString('base64');
}

function getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2-lat1);  // deg2rad below
  var dLon = deg2rad(lon2-lon1); 
  var a = 
    Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * 
    Math.sin(dLon/2) * Math.sin(dLon/2)
    ; 
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
  var d = R * c; // Distance in km
  return d;
}

function deg2rad(deg) {
  return deg * (Math.PI/180)
}

module.exports = router;