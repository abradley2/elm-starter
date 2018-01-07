const router = require('express').Router;
const cors = require('cors');

const api = router();

api.use(cors());
api.use('/quests', require('./routes/quests'));

module.exports = api;
