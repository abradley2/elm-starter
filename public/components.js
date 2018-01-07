(function () {
    const M = window.M; // eslint-disable-line no-undef
    const instances = {};

    const components = {
        textField: {
            mount: function (elem, id) {
                console.log('mount = ', id);
            },
            unmount: function (elem, id) {
                console.log('unmount = ', id);
            }
        },
        sidenav: {
            mount: function (elem, id) {
                instances[id] = new M.Sidenav(elem, {});
            },
            unmount: function (elem, id) {
                instances[id].destroy();
            }
        }
    };

    window.Components = { // eslint-disable-line no-undef
        mount: function (elem, componentType, app) {
            const id = elem.getAttribute('data-elm-lifecycle');
            components[componentType].mount(elem, id, app);
        },

        unmount: function (elem, componentType, app) {
            const id = elem.getAttribute('data-elm-lifecycle');
            components[componentType].mount(elem, id, app);
        }
    };
})();
