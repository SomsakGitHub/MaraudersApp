const { validationResult } = require('express-validator')

module.exports = {
  providerLogin (req, res) {
    const errors = validationResult(req)
    if (!errors.isEmpty()) {
      return res.status(422).json({ errors: errors.array() })
    } else {
      return true
    }
  }
}
