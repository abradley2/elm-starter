const router = require('express').Router;
const cors = require('cors');

const api = router();

api.use(cors());
api.use('/armies', require('./routes/armies'));

module.exports = api;
