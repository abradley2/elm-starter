const M = window.M
const instances = {}

const components = {
  textField: {
    mount() {
      M.updateTextFields()
    },
    unmount() {
    }
  },
  sidenav: {
    mount(elem, id) {
      instances[id] = new M.Sidenav(elem, {})
    },
    unmount(elem, id) {
      instances[id].destroy()
    }
  }
}

module.exports = {
  mount(elem, componentType, app) {
    const id = elem.getAttribute('data-elm-lifecycle')
    components[componentType].mount(elem, id, app)
  },

  unmount(elem, componentType, app) {
    const id = elem.getAttribute('data-elm-lifecycle')
    components[componentType].mount(elem, id, app)
  }
}
