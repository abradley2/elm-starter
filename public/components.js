(function () {
  const M = window.M
  const instances = {}

  const components = {
    textField: {
      mount: function () {
        M.updateTextFields()
      },
      unmount: function () {
      }
    },
    sidenav: {
      mount: function (elem, id) {
        instances[id] = new M.Sidenav(elem, {})
      },
      unmount: function (elem, id) {
        instances[id].destroy()
      }
    }
  }

  window._Components = { // eslint-disable-line no-undef
    mount: function (elem, componentType, app) {
      const id = elem.getAttribute('data-elm-lifecycle')
      components[componentType].mount(elem, id, app)
    },

    unmount: function (elem, componentType, app) {
      const id = elem.getAttribute('data-elm-lifecycle')
      components[componentType].mount(elem, id, app)
    }
  }
})()
