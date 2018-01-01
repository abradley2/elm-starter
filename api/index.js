const router = require('express').Router;

const api = router();

api.use('/armies', require('./routes/armies'));

module.exports = api;
