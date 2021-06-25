const express = require('express')
const router = express.Router()
const { check } = require('express-validator')

const AuthModule = require('./modules/auth')

router.get('/', (_, res) => {
  res.send('marauders')
})

const providerLoginValidate = [
  check('displayName').isString(),
  check('email').isEmail(),
  check('photoUrl').isString(),
  check('provideId').isString(),
  check('uid').isString()
]

router.post('/v1/auth/provider-login', providerLoginValidate, AuthModule.providerLogin)

module.exports = router
