
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
    return;
  }
  let request = new XMLHttpRequest();
  console.log({ method, url, data, handler });
  request.open(method, url, true);
  request.setRequestHeader('X-CSRF-TOKEN', document.querySelector('meta[name="csrf-token"]').content);
  request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
  request.addEventListener('load', handler);
  request.send(encodeForAjax(data));
}

function sendGetRequest(url, data, handler) {
  let request = new XMLHttpRequest();
  console.log()
  request.open("get", `${url}?` + encodeForAjax(data), true);
  request.addEventListener('load', handler);
  request.send();

}

function emptyInput(input) {
  input.value = '';
}

function insertAfter(referenceNode, newNode) {
  referenceNode.parentNode.insertBefore(newNode, referenceNode.nextSibling);
}

function mappingDifDateDescript(date) {
  let now = new Date();
  const diffTime = Math.abs(new Date(date) - now);
  console.log(diffTime);
  const diffYears = Math.floor(diffTime / (1000 * 60 * 60 * 24 * 365)); 
  if (diffYears > 1) return diffYears + " years ago";
  else if (diffYears === 1) return " a year ago";

  const diffMonths = Math.floor(diffTime / (1000 * 60 * 60 * 24 * 30));
  if (diffMonths> 1) return diffYears + " months ago";
  else if (diffMonths === 1) return " a month ago";

  const diffWeeks = Math.floor(diffTime / (1000 * 60 * 60 * 24 * 7));
  if (diffWeeks > 1) return diffYears + " weeks ago";
  else if (diffWeeks === 1) return " a week ago";

  const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24)); 
  if (diffDays > 1) return diffYears + " days ago";
  else if (diffDays === 1) return " yesterday";

  const diffHours = Math.floor(diffTime / (1000 * 60 * 60)); 
  console.log(diffHours);
  if (diffHours > 1) return diffYears + " hours ago";
  else if (diffHours === 1) return " a hour ago";

  const diffMins = Math.floor(diffTime / (1000 * 60)); 
  if (diffMins > 3) return diffYears + " minutes ago";
  else if (diffMins === 1) return " just now";
 
}

// ========================================
// ===== Dealing with notifications =======
// ========================================
const dropdown_notification= document.querySelector('.notification-dropdown');
const dropdown_notification_tittle = document.querySelector('.notification-title');
const user_id = document.querySelector('ul').getAttribute('data-user');
console.log(user_id);
Pusher.logToConsole = true;
var pusher = new Pusher('7d3a9c163bd45174c885', {
  cluster: 'eu',
  forceTLS: true,
  auth: {
    headers: {
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    }
  },
});

let kicking_channel = pusher.subscribe('private-kicked.' + user_id);

kicking_channel.bind('kicked-out', (data) => {
  console.log(data);
  
  let new_notification = document.createElement('div');
  new_notification.classList.add('notify_item','clickable');
  new_notification.innerHTML = `
    <div class="notify_img">
      <img
        src="/assets/profile.png"
        alt="profile_pic"
        style="width: 50px"
      />
    </div>
    <div class="notify_info">
      <p>${data['sender']} kicked you out of <span>T${data['project']}</span></p>
      <span class="notify_time">${mappingDifDateDescript(data['date'])}</span>
    </div>
  `;

  insertAfter( dropdown_notification_tittle, new_notification);

});

let invitation_channel = pusher.subscribe('private-invited.' + user_id);

/* {todo} check if path exists */
invitation_channel.bind('invitation', function(data) {
  console.log(data);
  
  let new_notification = document.createElement('div');
  new_notification.classList.add('notify_item','clickable');
  new_notification.innerHTML = `
    <div class="notify_img">
      <img
        src="/assets/profile.png"
        alt="profile_pic"
        style="width: 50px"
      />
    </div>
    <div class="notify_info">
      <p>${data['sender']} invite you to <span>T${data['project']}</span></p>
      <span class="notify_time">${mappingDifDateDescript(data['date'])}</span>
    </div>
  `;

  insertAfter( dropdown_notification_tittle, new_notification);


});






