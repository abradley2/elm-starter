const router = require('express').Router;
const redis = require('../redis');

const armiesRoute = router();
function armiesListKey(username = 'demo') {
    return `armies:${username}`;
}

function getArmies(req, res) {
    const log = req.app.locals.log;

    return redis.lrange(
        armiesListKey(),
        0,
        -1
    )
        .then(armies => {
            return res.json(armies || []);
        })
        .catch(err => {
            log.error(err);
            return res.json(err);
        });
}

armiesRoute.get('/', getArmies);

armiesRoute.post('/', function (req, res) {
    const log = req.app.locals.log;

    return redis.rpush(
        armiesListKey(),
        req.body.name
    )
        .then(() => {
            return getArmies(req, res);
        })
        .catch(err => {
            log.error(err);
            return res.json(err);
        });
});

armiesRoute.put('/:index', function (req, res) {
    const log = req.app.locals.log;

    return redis.lset(
        armiesListKey(),
        req.params.index,
        req.body.name
    )
        .then(() => {
            return getArmies(req, res);
        })
        .catch(err => {
            log.error(err);
            return res.json(err);
        });
});

armiesRoute.delete('/:index', function (req, res) {
    const log = req.app.locals.log;

    return redis.ltrim(
        armiesListKey(),
        req.params.index
    )
        .then(() => {
            return getArmies(req, res);
        })
        .catch(err => {
            log.error(err);
            return res.json(err);
        });
});

module.exports = armiesRoute;
