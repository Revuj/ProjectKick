const active_button = document.querySelector('#tables-types > li:nth-child(1)');
const finished_button = document.querySelector(
  '#tables-types > li:nth-child(2)'
);

active_button.addEventListener('click', event => {
  event.preventDefault();

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
  const finished_list = document.querySelector('div.p-2:nth-child(5)');
  if (finished_list.classList.contains('d-none')) {
    const active_list = document.querySelector('div.p-2:nth-child(4)');

    finished_list.classList.remove('d-none');
    active_list.classList.add('d-none');

    active_button.classList.remove('active');
    finished_button.classList.add('active');
  }
});



const create_button = document.getElementById("create-project");

function createProjectHandler() {
  const response = JSON.parse(this.responseText);
  console.log(response);
  let name = response.name;
  let id = response.id;
  let description = response.description;
  let creation_date = response.creation_date;

  let active_projects = document.getElementById("active-projects");
  let project_card = document.createElement('div');
  project_card.classList.add("card", "project");
  project_card.id = id;
  project_card.innerHTML =
    `<div class="card-header">
      <a
        class="text-decoration-none title"
        href="project_overview.html"
        >${ name}

      </a>
      <br />
      <span class="font-weight-lighter">Created at </span>
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
            style="width: 80%;">
          </div>
        </div>
        <div>
          Tasks Completed:<span class="text-inverse">36/94</span>
        </div>
        </div>
        <div class="mt-3 project-members">
        </div>
    </div>
    <div class="d-flex justify-content-left card-footer"></div>`

  active_projects.appendChild(project_card);
}


create_button.addEventListener('click', event => {
  let name = document.getElementById("project-name").value;
  let description = document.getElementById("project_description").value;
  let author_id = create_button.dataset.user;
  console.log({ name, description, author_id });
  sendAjaxRequest("put", `/api/projects`, { name, description, author_id }, createProjectHandler);
});


const deleteButton = document.getElementById("delete-project-button");
deleteButton.addEventListener('click', deleteUser);

function deleteHandler() {
  const response = JSON.parse(this.responseText);
  let id = response.id;
  let project = document.getElementById(id);
  project.remove();
}

function deleteUser(e) {
  e.preventDefault();
  let id = deleteButton.dataset.project;
  console.log(id);
  sendAjaxRequest("delete", `/api/projects/${id}`, {}, deleteHandler);
}