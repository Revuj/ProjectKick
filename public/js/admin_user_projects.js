const users_button = document.querySelector('#tables-types > li:nth-child(1)');
const projects_button = document.querySelector(
  '#tables-types > li:nth-child(2)'
);

let active_projects = false;

const filter_user = document.getElementById('filter-select-user');
const filter_project = document.getElementById('filter-select-project');

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

let project_text = document.querySelector('#text-filter');
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

});


function requestProjects(option) {
  let data = {
    option : option,
    order : sort_asc,
    search : project_text.value
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


