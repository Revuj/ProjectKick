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
(function() {
  if (localStorage.getItem("theme") === "dark") {
    try {
      document.getElementById("slider").checked = true;
    } catch {}
    setTheme("dark");
  } else {
    setTheme("light");
  }
})();
