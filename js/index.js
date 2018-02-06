const axios = require('axios')
const cookies = require('js-cookie')
const cuid = require('cuid')
const components = require('./components')

const apiEndpoint = process.env.NODE_ENV === 'production' ?
  '/' :
  'http://localhost:5000/'

const app = window.Elm.Main.embed(
  document.getElementById('app'),
  {
    apiEndpoint,
    env: process.env.NODE_ENV
  }
)

document.addEventListener('animationstart', e => {
  if (e.animationName === 'nodeInserted') {
    const parent = e.target.parentElement
    const target = e.target
    const targetId = target.id
    const componentType = target.getAttribute('data-js-component')

    if (componentType) {
      components.mount(target, componentType, app)
    }
    app.ports.mount.send([targetId, componentType])

    const observer = new MutationObserver(ev => {
      if (ev[0].removedNodes && ev[0].removedNodes.length !== 0) {
        ev[0].removedNodes.forEach(node => {
          if (node === target) {
            if (componentType) {
              components.unmount(target, componentType, app)
            }
            app.ports.unmount.send(targetId)
            observer.disconnect()
          }
        })
      }
    })
    observer.observe(parent, {childList: true})
  }
}, false)

const qs = window.location.search.substr(1).split('&').reduce((obj, cur) => {
  return Object.assign(obj, {
    [cur.split('=')[0]]: cur.split('=')[1]
  })
}, {})

const token = cookies.get('thyQuestIs:token')

if (token) {
  app.ports.loadToken.send(token)
}

app.ports.requestQuestId.subscribe(() => {
  app.ports.loadQuestId.send(cuid())
})

app.ports.requestQuestStepId.subscribe(prevStepId => {
  app.ports.loadQuestStepId.send(prevStepId, cuid())
})

app.ports.uploadQuestImage.subscribe(inputId => {
  const fileInput = document.getElementById(inputId)

  if (!fileInput) {
    return
  }

  const data = new FormData()

  data.append('file', fileInput.files[0])

  axios({
    method: 'POST',
    url: 'http://localhost:5000/upload',
    data,
    headers: {
      Authorization: 'bearer ' + cookies.get('thyQuestIs:token')
    }
  })
    .then(res => {
      app.ports.uploadQuestImageFinished.send([true, res.data.file])
    })
    .catch(() => {
      app.ports.uploadQuestImageFinished.send([false, 'error'])
    })
})

if (qs && qs.code) {
  axios.post('http://localhost:5000/session/login', {code: qs.code})
    .then(res => {
      cookies.set('thyQuestIs:token', res.data.token)
      app.ports.loadToken.send(res.data.token)
    })
    .catch(err => {
      console.error(err)
    })

  setTimeout(() => {
    history.replaceState(document.title, {}, '/')
  }, 0)
}
