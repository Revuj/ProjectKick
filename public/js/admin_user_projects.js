const users_button = document.querySelector('#tables-types > li:nth-child(1)');
const projects_button = document.querySelector(
  '#tables-types > li:nth-child(2)'
);

let active_projects = false;

const filter_user = document.getElementById('filter-select-user');
const filter_project = document.getElementById('filter-select-project');
const ban_btns = document.querySelectorAll('.ban');
const unban_btns = document.querySelectorAll('.unban');


users_button.addEventListener('click', event => {
  event.preventDefault();

  const user_list = document.querySelector('#users');
  if (user_list.classList.contains('d-none')) {
    const projects_list = document.querySelector('#projects');

    user_list.classList.remove('d-none');
    projects_list.classList.add('d-none');
    users_button.classList.add('active');
    projects_button.classList.remove('active');

     filter_user.classList.remove('d-none');
    filter_project.classList.add('d-none');
    active_projects = false;
  }
});

projects_button.addEventListener('click', event => {
  event.preventDefault();

  const projects_list = document.querySelector('#projects');
  if (projects_list.classList.contains('d-none')) {
    const user_list = document.querySelector('#users');

    projects_list.classList.remove('d-none');
    user_list.classList.add('d-none');

    users_button.classList.remove('active');
    projects_button.classList.add('active');

    filter_user.classList.add('d-none');
    filter_project.classList.remove('d-none');
    active_projects = true;
  }
});

let sort_asc = true;
let degree = 0;
let arrow = document.querySelector('#orderType');
let selectable_user = document.querySelector('#filter-select-user');
let selectable_project = document.querySelector('#filter-select-project');

let value_input_text = document.querySelector('#text-filter');
let button_search = document.querySelector('#searchbarbutton');



arrow.addEventListener('click', function (e) {
  e.preventDefault();

  let option = (active_projects) ? selectable_project.options[selectable_project.selectedIndex].text
                                  : selectable_user.options[selectable_user.selectedIndex].text
  console.log(option)
  //let author_id = create_button.dataset.user;

  degree = (degree + 180) % 360;
  arrow.style.transform = "rotateX(0deg) rotate(" + degree + "deg)";

  sort_asc = !sort_asc;
  /*ajax call */
});

button_search.addEventListener('click', (e) => {
    e.preventDefault();
    let option = (active_projects) ? selectable_project.options[selectable_project.selectedIndex].text
    : selectable_user.options[selectable_user.selectedIndex].text;

    if (active_projects === true) {
      requestProjects(option);
    }
    else if (active_projects === false) {
      requestUsers(option);
    }

});


function requestProjects(option) {
  let data = {
    option : option,
    order : sort_asc,
    search : value_input_text.value
  };
  let init = {
    method: 'POST',
    body: encodeForAjax(data),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }

  fetch(`/admin/fetchProjects`, init)
  .then(function (response) {
    if (response.ok) {
      response.json().then(data => {
        if ('message' in data) {
          alert(response['message']);
        }
        else {
          console.log(data);
        }
      })
    }
    else {
    
      console.log('Network response was not ok.' + JSON.stringify(data));
    }
  }).catch(function (error) {
    console.log('There has been a problem with your fetch operation: ' + error.message);
  });
}


function requestUsers(option) {
  let data = {
    option : option,
    order : sort_asc,
    search : value_input_text.value
  };
  let init = {
    method: 'POST',
    body: encodeForAjax(data),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }

  fetch(`/admin/fetchUsers`, init)
  .then(function (response) {
    if (response.ok) {
      response.json().then(data => {
        if ('message' in data) {
          alert(response['message']);
        }
        else {
          console.log(data);
          renderUsers(data[0]);
        }
      })
    }
    else {
    
      console.log('Network response was not ok.' + JSON.stringify(data));
    }
  }).catch(function (error) {
    console.log('There has been a problem with your fetch operation: ' + error.message);
  });
}

function getUnbanBtn(user_id) {
    let unban_btn = document.createElement('button');
    unban_btn.classList.add("btn", "btn-outline-success", "px-1", "unban");
    unban_btn.setAttribute('data-target', user_id);
    unban_btn.innerHTML = `
      <i class="fa fa-ban fa-check" aria-hidden="true"></i>
      Unban`;
    unban_btn.addEventListener('click', () => {
      unbanUser.call(unban_btn);
    });

    return unban_btn;
    
}

function getBanBtn( user_id) {
  let ban_btn = document.createElement('button');
  ban_btn.classList.add("btn", "btn-outline-danger", "ban");
  ban_btn.setAttribute('data-target', user_id);
  ban_btn.innerHTML = `
    <i class="fas fa-ban" aria-hidden="true"></i>
    Ban `;

  ban_btn.addEventListener('click', () => {
      banUser.call(ban_btn);
  });
  
  return ban_btn;  
}

ban_btns.forEach(ban_btn => 
  ban_btn.addEventListener('click', () => {
   banUser.call(ban_btn);
}));

unban_btns.forEach(unban_btn => 
  unban_btn.addEventListener('click', () => {
  unbanUser.call(unban_btn);
}));


function banUser() {

  let id = this.getAttribute('data-target');
  let unban_btn = getUnbanBtn(id);
  let element = this;

  let init = {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }

  fetch(`/admin/banUser/${id}`, init)
  .then(function (response) {
    if (response.ok) {
      response.json().then(data => {
        if ('message' in data) {
          alert(response['message']);
        }
        else {
          console.log(data);
          element.replaceWith(unban_btn);
        }
      })
    }
    else {
    
      console.log('Network response was not ok.' + JSON.stringify(data));
    }
  }).catch(function (error) {
    console.log('There has been a problem with your fetch operation: ' + error.message);
  });

  
}

function unbanUser() {
  let id = this.getAttribute('data-target');
  let ban_btn = getBanBtn(id);
  let element = this;
  let init = {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }
  fetch(`/admin/unbanUser/${id}`, init)
  .then(function (response) {
    if (response.ok) {
      response.json().then(data => {
        if ('message' in data) {
          alert(response['message']);
        }
        else {
          console.log(data);
          element.replaceWith(ban_btn);
        }
      })
    }
    else {
    
      console.log('Network response was not ok.' + JSON.stringify(data));
    }
  }).catch(function (error) {
    console.log('There has been a problem with your fetch operation: ' + error.message);
  });

}

function getUserRow(user) {

  let tr = document.createElement('tr');
  
  /*username */
  let td_username = document.createElement('td');
  td_username.setAttribute('data-label', "User");
  td_username.innerHTML = `
    <img src= "/assets/avatars/${user['photo_path']}.png" alt="profile picture" />
    <a href="#" class="user-link">${user['username']}</a>
  `;

  /*date */
  let date = new Date(user['creation_date']).toString();
  let separator = date.split(' ');
  let td_date = document.createElement('td');
  td_date.classList.add('text-center');
  td_date.setAttribute('data-label', "Created");
  td_date.innerHTML = `
    ${separator[2]} ${separator[1]}  ${separator[3]}
  `;

  /*status */
  let status = (user['is_banned']) ? 'banned' : 'normal';
  let td_status = document.createElement('td');
  td_status.setAttribute('data-label', 'Status');
  td_status.classList.add('align-center');
  if (status === 'normal') {
    td_status.innerHTML = `
      <span class="badge text-success">
        ${status}
      </span>
    `;
  } else {
    td_status.innerHTML = `
    <span class="badge text-danger">
      ${status}
    </span>
  `;
  }

  /*email */
  let td_email = document.createElement('td');
  td_email.classList.add('text-center');
  td_email.setAttribute('data-label', 'Email');
  td_email.innerHTML = `
  <a href="#"> ${user['email']}</a>
  `;


  /*button */
  let user_id = user['id'];
  let td_button = document.createElement('td');
  td_button.classList.add('text-center');
  let tdbutton = (user['is_banned']) ?  getUnbanBtn(user_id) : getBanBtn(user_id);
  td_button.appendChild(tdbutton);

  tr.appendChild(td_username);
  tr.appendChild(td_date);
  tr.appendChild(td_status);
  tr.appendChild(td_email);
  tr.appendChild(td_button);

  return tr;
}


function renderUsers(users) {

  const info_users = document.querySelector('#users tbody');

  while (info_users.firstChild) {
    info_users.removeChild(info_users.firstChild);
  }

  users.forEach(user => {
    info_users.appendChild(getUserRow(user));
  })
}



