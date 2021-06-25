const express = require('express');
const router = express.Router();
const User = require('../models/User')
const nodemailer = require("nodemailer");
var crypto = require('crypto');
const algorithm = 'aes-256-ctr';
const ENCRYPTION_KEY = 'myPassword';
const IV_LENGTH = 16;

//Get all routes.
router.get('/', async (req, res) => {
  try {
    const user = await User.find();

    res.status(200).json(user);
  } catch (error) {
    res.status(400).json({ msg: error });
  }
})

//Get specific routes.
router.get('/:id', async (req, res) => {
  try {
    const q = await User.findById({ _id: req.params.id });

    res.status(200).json(q);
  } catch (error) {
    res.status(400).json({ msg: error });
  }
})

//Authentication email.
router.post('/authentication', async (req, res) => {

  const newUser = new User(req.body);
  let decryptPassword = decrypt("0251a3869570d5ad4e972d671ebbdd72:bb1cec9dcfbec99f04ff88ee");
  let codeNumber = Math.floor(100000 + Math.random() * 900000)

  // console.log("decryptPassword", decryptPassword)

  //Config transporter email.
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'findfriendsapplication@gmail.com',
      pass: decryptPassword
    }
  });

  let mailOptions = {
    from: 'findFriendsApp',                     // sender
    to: newUser.email.toString(),               // list of receivers
    subject: 'Authentication code.',            // Mail subject
    text: codeNumber.toString()                 // text
  };

  transporter.sendMail(mailOptions, function (err, info) {
    if (err) {
      console.log("err", err)
      res.status(400).json({ msg: err })
    }else{
      console.log("info", info);
      res.status(200).json({ code: codeNumber});
    }  
  });
});

//Create new user.
router.post('/register', async (req, res) => {

  try {
    const email = await User.find({ email: req.body.email });

    if (email.length > 0) {
      res.status(400).json({ msg: email });
    }else{
      const newUser = new User(req.body);
      const saveUser = await newUser.save();

      res.status(200).json(saveUser);
    }
  } catch (error) {
    res.status(400).json({ msg: error });
  }
});

//Login.
router.post('/login', async (req, res) => {

  try {
    const email = await User.find({ email: req.body.email });
    console.log("email", email)

    if (email.length > 0) {
      console.log("email.length", email.length)
      const password = await email.find(element => element.password === req.body.password);

      if (password != undefined) {
        res.status(200).json(email);
      }else{
        res.status(404).json({ msg: password });
      }
    }else{
      res.status(400).json({ msg: email });
    }
  } catch (error) {
    res.status(400).json({ msg: error });
  }
});

//Forgot password.
router.patch('/forgotPassword', async (req, res) => {

  try {
    const email = await User.find({ email: req.body.email });
    console.log("email", email)

    if (email.length > 0) {
      console.log("email.length", email.length)

      let decryptPassword = decrypt("0251a3869570d5ad4e972d671ebbdd72:bb1cec9dcfbec99f04ff88ee");
      let codeNumber = Math.floor(100000 + Math.random() * 900000)

      // console.log("decryptPassword", decryptPassword)

      //Config transporter email.
      const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: 'findfriendsapplication@gmail.com',
          pass: decryptPassword
        }
      });

      let mailOptions = {
        from: 'findFriendsApp',                     // sender
        to: req.body.email.toString(),              // list of receivers
        subject: 'New password.',                   // Mail subject
        text: codeNumber.toString()                 // text
      };

      transporter.sendMail(mailOptions, async function (err, info) {
        if (err) {
          console.log("err", err)
          res.status(400).json({ msg: err })
        }else{
          console.log("info", info);
          const updatePassowrd = await User.updateOne({ email: req.body.email }, { password: encrypt(codeNumber.toString()) });
          res.status(200).json(updatePassowrd);
        }  
      });
    }else{
      res.status(400).json({ msg: email });
    }
  } catch (error) {
    res.status(400).json({ msg: error });
  }
});

//Update user.
router.patch('/:id', async (req, res) => {

  try {
    const q = await User.updateOne({ _id: req.params.id }, { $set: req.body });

    res.status(200).json(q);
  } catch (error) {
    res.status(400).json({ msg: error });
  }
})

//Delete user.
router.delete('/:id', async (req, res) => {

  try {
    const result = await User.findByIdAndDelete({ _id: req.params.id });

    res.status(200).json(result);
  } catch (error) {
    res.status(400).json({ msg: error });
  }
})

function encrypt(text) {
  let key = crypto.createHash('sha256').update(String(ENCRYPTION_KEY)).digest('base64').substr(0, 32);
  let iv = crypto.randomBytes(IV_LENGTH);
  let cipher = crypto.createCipheriv(algorithm, key, iv);
  let encrypted = cipher.update(text);
  encrypted = Buffer.concat([encrypted, cipher.final()]);
  return iv.toString('hex') + ':' + encrypted.toString('hex');
}

function decrypt(text) {
  let key = crypto.createHash('sha256').update(String(ENCRYPTION_KEY)).digest('base64').substr(0, 32);
  let textParts = text.split(':');
  let iv = Buffer.from(textParts.shift(), 'hex');
  let encryptedText = Buffer.from(textParts.join(':'), 'hex');
  let decipher = crypto.createDecipheriv(algorithm, key, iv);
  let decrypted = decipher.update(encryptedText);
  decrypted = Buffer.concat([decrypted, decipher.final()]);
  return decrypted.toString();
}

module.exports = router;