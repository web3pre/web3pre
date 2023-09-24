/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable no-unused-vars */
const express = require('express')
const passport = require('passport')
const session = require('express-session')

// Passport vanilla configuration
passport.serializeUser((user, done) => {
  done(null, user)
})

passport.deserializeUser((user, done) => {
  done(null, user)
})

const configureUnlock = require('@unlock-protocol/unlock-express')

const app = express()
const port = 3000

app.use(
  session({
    secret: 'right click download',
  })
)

app.use(passport.session()) // persistent login session

const { membersOnly } = configureUnlock(
  {
    locks: {
      '0x132a1c0966b661e92fb304c8d7bc76a5e913b325': {
        network: 8453,
      },
    },
  },
  passport
)

// Public page!
app.get('/', (req, res) => {
  res.send('Welcome! <a href="/members">members only</a>')
})

// Members only page
// You could pass a custom paywallConfig object to the `membersOnly` middleware, or
// even wrap that middleware into a custom one if you want to customize the paywallConfig
// based on the request object.
app.get('/members', membersOnly(), (req, res) => {
  res.send('Secret stuff! <a href="/">go home</a>')
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})
