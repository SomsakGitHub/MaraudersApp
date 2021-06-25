const mongoose = require('mongoose');

const TimeLineSchema = new mongoose.Schema({
    user_id:{
        type: String, 
        required: false
    },
    image: String,
    caption: String,
    latitude: Number,
    longitude: Number
});

module.exports = mongoose.model('TimeLine', TimeLineSchema)