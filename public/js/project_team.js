const developer_button = document.querySelector(
  "#tables-types > li:nth-child(1)"
);
const coordinator_button = document.querySelector(
  "#tables-types > li:nth-child(2)"
);

const all_button = document.querySelector("#tables-types > li:nth-child(3)");

const addMemberButton = document.getElementById("add-member");
const removeMemberButton = document.getElementById("remove-member");
const leaveButton = document.getElementById("leave-button");
const promoteMemberButton = document.getElementById("promote-member");

let developer_list = document.querySelector("#developers");
let coordinator_list = document.querySelector("#coordinators");
let all_list = document.querySelector("#all");

console.log(all_button);
console.log(all_list);

developer_button.addEventListener("click", (event) => {
  event.preventDefault();
  if (developer_list.classList.contains("d-none")) {
    all_list.classList.add("d-none");
    all_button.classList.remove("active");
    developer_list.classList.remove("d-none");
    coordinator_list.classList.add("d-none");
    developer_button.classList.add("active");
    coordinator_button.classList.remove("active");
  }
});

coordinator_button.addEventListener("click", (event) => {
  event.preventDefault();
  if (coordinator_list.classList.contains("d-none")) {
    all_list.classList.add("d-none");
    all_button.classList.remove("active");
    coordinator_list.classList.remove("d-none");
    developer_list.classList.add("d-none");
    developer_button.classList.remove("active");
    coordinator_button.classList.add("active");
  }
});

all_button.addEventListener("click", (event) => {
  event.preventDefault();
  if (all_list.classList.contains("d-none")) {
    all_list.classList.remove("d-none");
    all_button.classList.add("active");
    coordinator_list.classList.add("d-none");
    developer_list.classList.add("d-none");
    developer_button.classList.remove("active");
    coordinator_button.classList.remove("active");
  }
});

const user_infos = document.querySelectorAll(".info");
console.log(user_infos);

user_infos.forEach((elem) =>
  elem.addEventListener("mouseover", (event) => {
    event.preventDefault();
    let promote = elem.querySelector(".promote button");
    promote.classList.remove("d-none");
  })
);

user_infos.forEach((elem) =>
  elem.addEventListener("mouseleave", (event) => {
    event.preventDefault();
    let promote = elem.querySelector(".promote button");
    promote.classList.add("d-none");
  })
);

addMemberButton.addEventListener("click", async () => {
  event.preventDefault();

  let ddData = $("#users_dropdown").data("ddslick");
  let user_id =
    ddData != null && ddData.selectedData != null
      ? ddData.selectedData.value
      : "";
  let id = addMemberButton.dataset.project;
  let projectName = document.getElementById("project-name").innerHTML;
  let senderUsername = document.getElementById("auth-username");
  let senderId = senderUsername.dataset.id;
  senderUsername = senderUsername.innerHTML;

  const response = await fetch(`/api/projects/${id}/members`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-TOKEN": $('meta[name="csrf-token"]').attr("content"),
    },
    body: JSON.stringify({
      user_id,
      projectName,
      senderUsername,
      senderId,
    }),
  });

  if (response.ok) {
    $("#addMemberModal").modal("hide");
    $("#users_dropdown").ddslick("destroy");
  } else {
    $("#users_dropdown").ddslick("destroy");
    if (response.status === 403) {
      setError("You don't have permisson to add members");
    } else setError("An error occured during the request");
  }
});

removeMemberButton.addEventListener("click", () => {
  let user = removeMemberButton.dataset.user;
  let id = addMemberButton.dataset.project;
  let project = document.getElementById("project-name").innerHTML;
  let username = document.getElementById("auth-username");
  let sender = username.dataset.id;
  username = username.innerHTML;
  console.log({ id, user, project, username, project_id: id, sender });
  sendAjaxRequest(
    "delete",
    `/api/projects/${id}/members`,
    { user, project, username, sender },
    removeMemberHandler
  );
});

function removeMemberHandler() {
  const response = JSON.parse(this.responseText);
  
  if ('errors' in response) {
    console.log(response['errors']);
    displayError(response);
    return;
  }

  console.log(response);
  let id = response.user_id;
  let elements = document.getElementsByClassName(`user_${id}`);
  [...elements].forEach((elem) => elem.parentNode.removeChild(elem));
  let role = response.role;
  if (role === "developer")
    document.getElementById("developers-counter").innerHTML =
      parseInt(document.getElementById("developers-counter").innerHTML) - 1;
  else if (role === "coordinator")
    document.getElementById("coordinators-counter").innerHTML =
      parseInt(document.getElementById("coordinators-counter").innerHTML) - 1;

  document.getElementById("total-counter").innerHTML =
    parseInt(document.getElementById("total-counter").innerHTML) - 1;
}

promoteMemberButton.addEventListener("click", async () => {
  let user = promoteMemberButton.dataset.user;
  let id = addMemberButton.dataset.project;

  let response = await fetch(`/api/projects/${id}/members`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-TOKEN": $('meta[name="csrf-token"]').attr("content"),
    },
    body: JSON.stringify({ user, status: "coordinator" }),
  });

  if (response.ok) {
    let result = await response.json();
    promoteMemberHandler(result);
  }
});

function promoteMemberHandler(result) {
  let id = result.user_id;
  let element = document.getElementsByClassName(`user_${id}`);

  element[0].querySelector("td:nth-child(4)").remove();
  element[0].querySelector("td:nth-child(1) > span:nth-child(3)").textContent =
    result.role;

  element[1].parentNode.removeChild(element[1]);

  document.querySelector(
    "#coordinators > table:nth-child(1) > tbody:nth-child(2)"
  ).innerHTML += element[0].outerHTML;
  document.querySelector(
    "#all > table:nth-child(1) > tbody:nth-child(2)"
  ).innerHTML += element[0].outerHTML;

  document.getElementById("developers-counter").innerHTML =
    parseInt(document.getElementById("developers-counter").innerHTML) - 1;
  document.getElementById("coordinators-counter").innerHTML =
    parseInt(document.getElementById("coordinators-counter").innerHTML) + 1;

  element[0].parentNode.removeChild(element[0]);
}

leaveButton.addEventListener("click", async () => {
  let user = document.getElementById("auth-username").dataset.id;
  let id = addMemberButton.dataset.project;

  let response = await fetch(`/api/projects/${id}/members/leave`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-TOKEN": $('meta[name="csrf-token"]').attr("content"),
    },
    body: JSON.stringify({ user }),
  });

  if (response.ok) {
    window.location.replace(response.url);
  }
});

$("#remove-member-modal").on("show.bs.modal", function (event) {
  let button = $(event.relatedTarget);
  let username = button.data("username");
  let user = button.data("user");
  let modal = $(this);
  modal.find("#user-to-remove").text(username);
  removeMemberButton.dataset.user = user;
});

$("#promote-member-modal").on("show.bs.modal", function (event) {
  let button = $(event.relatedTarget);
  let username = button.data("username");
  let user = button.data("user");
  let modal = $(this);
  modal.find("#user-to-promote").text(username);
  promoteMemberButton.dataset.user = user;
});

const input = document.getElementById("username");
input.addEventListener("keyup", async (event) => {
  if (event.key === "Enter") {
    event.preventDefault();

    let url = "/api/users";
    let search = input.value;

    let response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-TOKEN": $('meta[name="csrf-token"]').attr("content"),
      },
      body: JSON.stringify({ search }),
    });

    if (response.ok) {
      let result = await response.json();
      $("#users_dropdown").ddslick("destroy");

      if (result.length === 0) {
        setError("No users match your search.");
      } else {
        $("#users_dropdown").ddslick({
          data: getDDData(result),
          width: "100%",
          heigth: 300,
          imagePosition: "left",
          selectText: "Select a user",
          onSelected: function (data) {},
        });
      }
    }
  }
});

function getDDData(result) {
  let ddData = [];

  result.forEach((elem) => {
    ddData.push({
      text: elem.username,
      value: elem.id,
      selected: false,
      description: elem.email,
      imageSrc: `/assets/avatars/${elem.photo_path}.png`,
    });
  });

  return ddData;
}

function setError(message) {
  let error = document.getElementById("error");
  error.innerHTML = `
  <div class="alert alert-danger alert-dismissible fade show" role="alert">
    ${message}
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
      <span aria-hidden="true">&times;</span>
    </button>
  </div>
  `;
}
