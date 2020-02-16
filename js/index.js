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