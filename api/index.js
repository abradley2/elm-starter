const router = require('express').Router;
const cors = require('cors');
const bodyParser = require('body-parser');
global.config = require('../config.js');

const api = router();

api.use(bodyParser.json());
api.use(cors());
api.use((req, res, next) => {
    if (req.headers.authorization) {
        res.locals.token = req.headers.authorization.split(' ').pop();
    }
    next();
});
api.use('/session', require('./routes/session'));
api.use('/quests', require('./routes/quests'));

module.exports = api;
