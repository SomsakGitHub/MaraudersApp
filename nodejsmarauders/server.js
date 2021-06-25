require('dotenv').config()
const express = require('express')
const mongoose = require('mongoose')

const app = express()
app.use(express.json())

mongoose.connect(process.env.MONGO_DB_CLUSTER_URL,
  { useNewUrlParser: true, useUnifiedTopology: true })

app.use('/', require('./router.js'))

app.listen(process.env.PORT, () => {
  console.log(`Application is running on port ${process.env.PORT}`)
})
