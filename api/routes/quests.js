const router = require('express').Router;
const redis = require('../redis');

const armiesRoute = router();
function questsListKey(username = 'demo') {
    return `quests:${username}`;
}

function getQuests(req, res) {
    const log = req.app.locals.log;

    return redis.lrange(
        questsListKey(),
        0,
        -1
    )
        .then(quests => {
            return res.json(quests || []);
        })
        .catch(err => {
            log.error(err);
            return res.json(err);
        });
}

armiesRoute.get('/', getQuests);

armiesRoute.post('/', function (req, res) {
    const log = req.app.locals.log;

    return redis.rpush(
        questsListKey(),
        req.body.name
    )
        .then(() => {
            return getQuests(req, res);
        })
        .catch(err => {
            log.error(err);
            return res.json(err);
        });
});

armiesRoute.put('/:index', function (req, res) {
    const log = req.app.locals.log;

    return redis.lset(
        questsListKey(),
        req.params.index,
        req.body.name
    )
        .then(() => {
            return getQuests(req, res);
        })
        .catch(err => {
            log.error(err);
            return res.json(err);
        });
});

armiesRoute.delete('/:index', function (req, res) {
    const log = req.app.locals.log;

    return redis.ltrim(
        questsListKey(),
        req.params.index
    )
        .then(() => {
            return getQuests(req, res);
        })
        .catch(err => {
            log.error(err);
            return res.json(err);
        });
});

module.exports = armiesRoute;
