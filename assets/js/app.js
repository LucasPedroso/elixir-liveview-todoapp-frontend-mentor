// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "../css/app.css";

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let darkTheme = localStorage.getItem("dark");

if (darkTheme === null) {
  darkTheme = false;
  localStorage.setItem("dark", false);
}

if (darkTheme === true) {
  dark_mode(true);
} else {
  dark_mode(false);
}

let Hooks = {};

Hooks.Dark = {
  beforeUpdate() {},
  mounted() {
    if (this.el.id == "dark") {
      this.el.addEventListener("click", (e) => {
        let dark = localStorage.getItem("dark");
        dark = dark === "true" ? true : false;
        localStorage.setItem("dark", !dark);

        if (!dark) {
          dark_mode(true);
        } else {
          dark_mode(false);
        }
      });
    }
    let dark = localStorage.getItem("dark");
    dark = dark === "true" ? true : false;
    dark_mode(dark);
    if (dark == null) {
      dark = false;
    }
    if (dark == true) {
      dark = true;
    }
  },

  updated() {
    if (this.el.id == "dark") {
      this.el.addEventListener("click", (e) => {
        let dark = localStorage.getItem("dark");
        dark = dark === "true" ? true : false;
        localStorage.setItem("dark", !dark);

        if (!dark) {
          dark_mode(true);
          console.log("dark mode true");
        } else {
          dark_mode(false);
          console.log("dark mode false");
        }
      });
    }
    let dark = localStorage.getItem("dark");
    dark = dark === "true" ? true : false;

    if (dark) {
      dark_mode(true);
    } else {
      dark_mode(false);
    }
  },
};

Hooks.FocusInputItem = {
  mounted() {
    focusInput(document.getElementById("update_todo"));
  },
  updated() {
    focusInput(document.getElementById("update_todo"));
  },
};

function dark_mode(is_dark) {
  var body = document.body;
  const formInput = document.querySelector(".form-input");
  const main = document.querySelector(".main");
  const footer = document.querySelector(".footer");
  if (is_dark == true) {
    body.classList.add("dark-mode");
    formInput.classList.add("dark-mode-todos");
    main.classList.add("dark-mode-todos");
    footer.classList.add("dark-mode-todos");
  } else {
    body.classList.remove("dark-mode");
    formInput.classList.remove("dark-mode-todos");
    main.classList.remove("dark-mode-todos");
    footer.classList.remove("dark-mode-todos");
  }
}

function focusInput(input) {
  const end = input.value.length;
  input.setSelectionRange(end, end);
  input.focus();
}

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) => topbar.show());
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
