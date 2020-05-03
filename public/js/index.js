
function showSignup() {
  const loginForm = document.getElementById("login-form");
  const signupForm = document.getElementById("signup-form");
  loginForm.style.display = "none";
  signupForm.style.display = "inline-block";
}

function showLogin() {
  const loginForm = document.getElementById("login-form");
  const signupForm = document.getElementById("signup-form");
  signupForm.style.display = "none";
  loginForm.style.display = "inline-block";
}

// function to set a given theme/color-scheme
function setTheme(themeName) {
  localStorage.setItem("theme", themeName);
  document.documentElement.className = themeName;
}
// function to toggle between light and dark theme
function toggleTheme() {
  if (localStorage.getItem("theme") === "dark") {
    setTheme("light");
  } else {
    setTheme("dark");
  }
}
// Immediately invoked function to set the theme on initial load
(function () {
  if (localStorage.getItem("theme") === "dark") {
    try {
      document.getElementById("slider").checked = true;
    } catch { }
    setTheme("dark");
  } else {
    setTheme("light");
  }
})();

// function to set the collapsed as true or false
function setCollapsed(collapsed) {
  let element = document.querySelector(".page-wrapper");
  if (element === null) return;
  localStorage.setItem("collapsed", collapsed);
  if (collapsed === "true")
    element.classList.add("is-collapsed");
  else element.classList.remove("is-collapsed");
}

// function to toggle between collapsed and non collapsed
function toggleCollapse() {
  if (localStorage.getItem("collapsed") === "true") {
    setCollapsed("false");
  } else {
    setCollapsed("true");
  }
}

// function to collapse side navbar
let hamburger_menus = document.querySelectorAll(".hamburger");
hamburger_menus.forEach(elem =>
  elem.addEventListener("click", function () {
    toggleCollapse();
  })
);

// Immediately invoked function to set the collapse on initial load
(function () {
  if (localStorage.getItem("collapsed") === "false") {
    setCollapsed("false");
  } else {
    setCollapsed("true");
  }
})();

// Ajax functions
function encodeForAjax(data) {
  if (data == null) return null;
  return Object.keys(data).map(function (k) {
    return encodeURIComponent(k) + '=' + encodeURIComponent(data[k])
  }).join('&');
}

function sendAjaxRequest(method, url, data, handler) {

  if (method === 'get') {
    sendGetRequest(url, data, handler);
  }
  let request = new XMLHttpRequest();
  console.log({ method, url, data, handler });
  request.open(method, url, true);
  request.setRequestHeader('X-CSRF-TOKEN', document.querySelector('meta[name="csrf-token"]').content);
  request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
  request.addEventListener('load', handler);
  request.send(encodeForAjax(data));
}

function sendGetRequest(url ,data, handler) {
  let request = new XMLHttpRequest();
  console.log()
  request.open("get", `${url}?` + encodeForAjax(data), true);
  request.addEventListener('load', handler);
  request.send();

}

function emptyInput(input) {
  input.value = '';
}
