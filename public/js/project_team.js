const developer_button = document.querySelector(
  '#tables-types > li:nth-child(1)'
);
const coordinator_button = document.querySelector(
  '#tables-types > li:nth-child(2)'
);

const all_button = document.querySelector(
  '#tables-types > li:nth-child(3)'
);

const addMemberButton = document.getElementById("add-member");
const removeMemberButton = document.getElementById("remove-member");

let developer_list = document.querySelector('#developers');
let coordinator_list = document.querySelector('#coordinators');
let all_list = document.querySelector('#all');

console.log(all_button);
console.log(all_list);


developer_button.addEventListener('click', event => {
  event.preventDefault();

  if (developer_list.classList.contains('d-none')) {
    all_list.classList.add('d-none');
    all_button.classList.remove('active');
    developer_list.classList.remove('d-none');
    coordinator_list.classList.add('d-none');
    developer_button.classList.add('active');
    coordinator_button.classList.remove('active');
  }
});

coordinator_button.addEventListener('click', event => {
  event.preventDefault();
  if (coordinator_list.classList.contains('d-none')) {
    all_list.classList.add('d-none');
    all_button.classList.remove('active');
    coordinator_list.classList.remove('d-none');
    developer_list.classList.add('d-none');
    developer_button.classList.remove('active');
    coordinator_button.classList.add('active');
  }
});

all_button.addEventListener('click', event => {
  event.preventDefault();
  if (all_list.classList.contains('d-none')) {
    all_list.classList.remove('d-none');
    all_button.classList.add('active');
    coordinator_list.classList.add('d-none');
    developer_list.classList.add('d-none');
    developer_button.classList.remove('active');
    coordinator_button.classList.remove('active');
  }
});

const user_infos = document.querySelectorAll('.info');
console.log(user_infos);

user_infos.forEach(elem =>
  elem.addEventListener('mouseover', event => {
    console.log('oioi');
    event.preventDefault();
    let promote = elem.querySelector('.promote button');
    promote.classList.remove('d-none');
  })
);

user_infos.forEach(elem =>
  elem.addEventListener('mouseleave', event => {
    event.preventDefault();
    let promote = elem.querySelector('.promote button');
    promote.classList.add('d-none');
  })
);

addMemberButton.addEventListener("click", () => {
  let receiver = document.getElementById("username").value;
  let roleRadio = document.getElementsByName("role");
  let role = "";
  if (roleRadio["0"].checked)
    role = "developer"
  else
    role = "coordinator";

  let id = addMemberButton.dataset.project;
  let projectName = document.getElementById('project-name').innerHTML;
  let senderUsername = document.getElementById('auth-username');
  let senderId = senderUsername.dataset.id;
  senderUsername = senderUsername.innerHTML;
  console.log({ id, receiver, role, projectName, senderUsername, senderId });
  sendAjaxRequest("post", `/api/projects/${id}/members`, { receiver, role, projectName, senderUsername, senderId }, inviteMemberHandler);
})

function inviteMemberHandler() {
  const response = JSON.parse(this.responseText);
  console.log(response)
  // mostrar mensagem se utilizador não existir
}

removeMemberButton.addEventListener("click", () => {
  let user = removeMemberButton.dataset.user;
  let id = addMemberButton.dataset.project;
  let project = document.getElementById('project-name').innerHTML;
  let username = document.getElementById('auth-username');
  let sender = username.dataset.id;
  username = username.innerHTML;
  console.log({ id, user, project, username, 'project_id': id, sender });
  sendAjaxRequest("delete", `/api/projects/${id}/members`, { user, project, username, sender }, removeMemberHandler);
})

function removeMemberHandler() {
  const response = JSON.parse(this.responseText);
  console.log(response)
  let id = response.user_id;
  let elements = document.getElementsByClassName(`user_${id}`);
  [...elements].forEach(elem => elem.parentNode.removeChild(elem));
  let role = response.role;
  if (role === "developer")
    document.getElementById("developers-counter").innerHTML = parseInt(document.getElementById("developers-counter").innerHTML) - 1;
  else if (role === "coordinator")
    document.getElementById("coordinators-counter").innerHTML = parseInt(document.getElementById("coordinators-counter").innerHTML) - 1;

  document.getElementById("total-counter").innerHTML = parseInt(document.getElementById("total-counter").innerHTML) - 1;

}

$('#remove-member-modal').on('show.bs.modal', function (event) {
  let button = $(event.relatedTarget)
  let username = button.data('username')
  let user = button.data('user')
  let modal = $(this)
  modal.find('#user-to-remove').text(username)
  removeMemberButton.dataset.user = user;
})
