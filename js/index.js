const axios = require('axios')
const cookies = require('js-cookie')
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
    const target = e.target
    const componentType = target.getAttribute('data-js-component')

    if (componentType) {
      components.mount(target, componentType, app)
    }
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

app.ports.uploadQuestImage.subscribe(inputId => {
  const fileInput = document.getElementById(inputId)

  if (!fileInput) {
    return
  }

  const data = new FormData()

  data.append('file', fileInput.files[0])

  axios({
    method: 'POST',
    url: apiEndpoint + 'upload',
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
  axios.post(apiEndpoint + 'session/login', {code: qs.code})
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
