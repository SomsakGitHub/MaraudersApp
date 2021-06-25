const mongoose = require('mongoose')

const { Schema } = mongoose
const productSchema = new Schema({
  _id: mongoose.Types.ObjectId(),
  userId: mongoose.Types.ObjectId(),
  provideId: String,
  uid: String
})
module.exports = mongoose.model('ProviderUser', productSchema)
