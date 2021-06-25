const mongoose = require('mongoose')

const { Schema } = mongoose
const productSchema = new Schema({
  _id: mongoose.Types.ObjectId(),
  displayName: String,
  email: String,
  photoUrl: Number
})
module.exports = mongoose.model('User', productSchema)
