const active_button = document.querySelector('#tables-types > li:nth-child(1)');
const finished_button = document.querySelector(
  '#tables-types > li:nth-child(2)'
);

active_button.addEventListener('click', event => {
  event.preventDefault();
  current_project_state = true;

  const active_list = document.querySelector('div.p-2:nth-child(4)');
  if (active_list.classList.contains('d-none')) {
    const finished_list = document.querySelector('div.p-2:nth-child(5)');

    active_list.classList.remove('d-none');
    finished_list.classList.add('d-none');
    active_button.classList.add('active');
    finished_button.classList.remove('active');
  }
});

finished_button.addEventListener('click', event => {
  event.preventDefault();
  current_project_state = false;
  const finished_list = document.querySelector('div.p-2:nth-child(5)');
  if (finished_list.classList.contains('d-none')) {
    const active_list = document.querySelector('div.p-2:nth-child(4)');

    finished_list.classList.remove('d-none');
    active_list.classList.add('d-none');

    active_button.classList.remove('active');
    finished_button.classList.add('active');
  }
});


const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Augt', 'Sep', 'Oct', 'Nov', 'Dec'];
let now = new Date();

const create_button = document.getElementById("create-project");
let createModal = document.getElementById("addProjectModal");
let toDelete;

function createProjectHandler() {
  const response = JSON.parse(this.responseText);
  $('#addProjectModal').modal('hide')
  console.log(response);

  if ('errors' in response) {
    displayError(response);
    return;
  }

  let name = response.name;
  let id = response.id;
  let description = response.description;
  let creation_date = response.creation_date;

  let active_projects = document.getElementById("active-projects");
  let project_card = document.createElement('div');
  project_card.classList.add("card-container", "col-lg-4", "col-md-6", "col-sm-12", "p-1");
  project_card.innerHTML =
    `<div class="card project" id="${id}">
      <div class="card-header d-flex align-items-center">
      <a
        class="text-decoration-none title"
        href="/projects/${id}"
        >${ name}
      </a>
      <button type="button" class="btn delete-project-button ml-auto" data-toggle="modal" data-target="#delete-project-modal" data-project="${id}">
        <i class="fas fa-trash-alt"></i>
      </button>
      <br />
      </div>
      <div class="card-body">
        <span id="description">
          <span>
            ${ description}
          </span>
        </span>
      <div>
        <div class="my-2 progress" style="height: 5px;">
          <div
            class="progress-bar"
            role="progressbar"
            aria-valuenow="80"
            aria-valuemin="0"
            aria-valuemax="100"
            style="width: 0%;">
          </div>
        </div>
        <div>
          Tasks Completed:<span class="text-inverse"> 0/0</span>
        </div>
        </div>
        <div class="mt-3 project-members">
        <div class="avatar-image avatar-image--loaded mr-2">
          <div class="avatar avatar--md avatar-image__image">
            <div class="avatar__content">
            <img src="  ./../assets/avatars/${createModal.dataset.photo}.png" alt="" />
            </div>
          </div>
        </div>
        </div>
    </div>
    <div class="d-flex justify-content-left card-footer">
      <span class="font-weight-lighter">Created at ${months[now.getMonth()]} ${now.getDay()} ${now.getYear() + 1900}</span>
    </div>
    </div>`

  active_projects.appendChild(project_card);
  project_card.querySelector('.delete-project-button').addEventListener('click', () => {
    toDelete = id;
  })
}


create_button.addEventListener('click', event => {
  let name = document.getElementById("project-name").value;
  let description = document.getElementById("project_description").value;
  let author_id = create_button.dataset.user;
  console.log({ name, description, author_id });
  sendAjaxRequest("put", `/api/projects`, { name, description, author_id }, createProjectHandler);
});


let deleteButtons = document.getElementsByClassName("delete-project-button");
[...deleteButtons].forEach(elem => elem.addEventListener('click', () => {
  toDelete = elem.dataset.project;
}))

const deleteButton = document.getElementById("delete-project-button");
deleteButton.addEventListener('click', deleteProject);

function deleteHandler() {
  const response = JSON.parse(this.responseText);
  let id = response.id;
  let project = document.getElementById(id);
  project.remove();
}

function deleteProject(e) {
  e.preventDefault();
  console.log(toDelete);
  sendAjaxRequest("delete", `/api/projects/${toDelete}`, {}, deleteHandler);
}

// ====== query, asc/desc, typeofSort, active
let sortAsc = true;
let degree = 0;
let arrow = document.querySelector('#orderType')
let selectable = document.querySelector('#filter-select')
let project_text = document.querySelector('#project-filter');
let button_search = document.querySelector('#searchbarbutton');

function searchHandler() {
  const response = JSON.parse(this.responseText);
  let projects = document.querySelectorAll(".project");
  if (response.length === 0) {
    projects.forEach(elem => { elem.style.display = "inline-block" });
    return;
  }
  projects.forEach(elem => { elem.style.display = "none" });
  response.forEach(elem => document.getElementById(elem.id).style.display = "inline-block");
}

button_search.addEventListener('click', (e) => {
  e.preventDefault();
  console.log(project_text.value)
  let search = project_text.value
  let author_id = create_button.dataset.user;
  let url = `/api/users/${author_id}/projects`;
  sendAjaxRequest("post", url, { search }, searchHandler);
})

function sorting() {
  const response = JSON.parse(this.responseText);
  console.log(response)
}


arrow.addEventListener('click', function (e) {
  e.preventDefault();
  let option = selectable.options[selectable.selectedIndex].text
  console.log(option)
  let author_id = create_button.dataset.user;

  degree = (degree + 180) % 360;
  arrow.style.transform = "rotateX(0deg) rotate(" + degree + "deg)";

  sortAsc = !sortAsc;

  let url = `/api/users/${author_id}/sort`;
  sendAjaxRequest("post", url, {
    'option': option,
    'order': sortAsc,
  }, sorting);

})

selectable.addEventListener('change', function (e) {

  let option = this.options[this.selectedIndex].text
  let author_id = create_button.dataset.user;

  let url = `/api/users/${author_id}/sort`;
  sendAjaxRequest("post", url, {
    'option': option,
    'order': sortAsc
  }, sorting);
});
