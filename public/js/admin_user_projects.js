const users_button = document.querySelector("#tables-types > li:nth-child(1)");
const projects_button = document.querySelector(
  "#tables-types > li:nth-child(2)"
);

let active_projects = false;

const filter_user = document.getElementById("filter-select-user");
const filter_project = document.getElementById("filter-select-project");
const ban_btns = document.querySelectorAll(".ban");
const unban_btns = document.querySelectorAll(".unban");
const delete_project = document.querySelectorAll(".delete-project button");

users_button.addEventListener("click", (event) => {
  event.preventDefault();

  const user_list = document.querySelector("#users");
  if (user_list.classList.contains("d-none")) {
    const projects_list = document.querySelector("#projects");

    user_list.classList.remove("d-none");
    projects_list.classList.add("d-none");
    users_button.classList.add("active");
    projects_button.classList.remove("active");

    filter_user.classList.remove("d-none");
    filter_project.classList.add("d-none");
    active_projects = false;
  }
});

projects_button.addEventListener("click", (event) => {
  event.preventDefault();

  const projects_list = document.querySelector("#projects");
  if (projects_list.classList.contains("d-none")) {
    const user_list = document.querySelector("#users");

    projects_list.classList.remove("d-none");
    user_list.classList.add("d-none");

    users_button.classList.remove("active");
    projects_button.classList.add("active");

    filter_user.classList.add("d-none");
    filter_project.classList.remove("d-none");
    active_projects = true;
  }
});

let sort_asc = true;
let degree = 0;
let arrow = document.querySelector("#orderType");
let selectable_user = document.querySelector("#filter-select-user");
let selectable_project = document.querySelector("#filter-select-project");

let value_input_text = document.querySelector("#text-filter");
let button_search = document.querySelector("#searchbarbutton");

arrow.addEventListener("click", function (e) {
  e.preventDefault();

  let option = active_projects
    ? selectable_project.options[selectable_project.selectedIndex].text
    : selectable_user.options[selectable_user.selectedIndex].text;
  console.log(option);
  //let author_id = create_button.dataset.user;

  degree = (degree + 180) % 360;
  arrow.style.transform = "rotateX(0deg) rotate(" + degree + "deg)";

  sort_asc = !sort_asc;
  /*ajax call */
});

button_search.addEventListener("click", (e) => {
  e.preventDefault();
  let option = active_projects
    ? selectable_project.options[selectable_project.selectedIndex].text
    : selectable_user.options[selectable_user.selectedIndex].text;

  if (active_projects === true) {
    requestProjects(option);
  } else if (active_projects === false) {
    requestUsers(option);
  }
});

function requestProjects(option) {
  let data = {
    option: option,
    order: sort_asc,
    search: value_input_text.value,
  };
  let init = {
    method: "POST",
    body: encodeForAjax(data),
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]').content,
    },
  };

  fetch(`/admin/fetchProjects`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then((data) => {
          if ("errors" in data) {
            console.log(data);
            console.log(data["errors"]);
            console.log("call1");
            displayError(data);
          } else {
            console.log(data);
            renderProjects(data[0]);
          }
        });
      } else {
        console.log("Network response was not ok." + JSON.stringify(data));
      }
    })
    .catch(function (error) {
      console.log(
        "There has been a problem with your fetch operation: " + error.message
      );
    });
}

function requestUsers(option) {
  let data = {
    option: option,
    order: sort_asc,
    search: value_input_text.value,
  };
  let init = {
    method: "POST",
    body: encodeForAjax(data),
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]').content,
    },
  };

  fetch(`/admin/fetchUsers`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then((data) => {
          if ("errors" in data) {
            displayError(data);
          } else {
            console.log(data);
            renderUsers(data[0]);
          }
        });
      } else {
        console.log("Network response was not ok." + JSON.stringify(data));
      }
    })
    .catch(function (error) {
      console.log(
        "There has been a problem with your fetch operation: " + error.message
      );
    });
}

function getUnbanBtn(user_id) {
  let unban_btn = document.createElement("button");
  unban_btn.classList.add("btn", "btn-outline-success", "px-1", "unban");
  unban_btn.setAttribute("data-target", user_id);
  unban_btn.innerHTML = `
      <i class="fa fa-ban fa-check" aria-hidden="true"></i>
      Unban`;
  unban_btn.addEventListener("click", () => {
    unbanUser.call(unban_btn);
  });

  return unban_btn;
}

function getBannedStatus() {
  let td_status = document.createElement("td");
  td_status.setAttribute("data-label", "Status");
  td_status.classList.add("align-center");

  td_status.innerHTML = `
    <span class="badge text-danger">
      banned
    </span>
  `;

  return td_status;
}

function getUnBannedStatus() {
  let td_status = document.createElement("td");
  td_status.setAttribute("data-label", "Status");
  td_status.classList.add("align-center");

  td_status.innerHTML = `
      <span class="badge text-success">
        normal
      </span>
  `;

  return td_status;
}

function getBanBtn(user_id) {
  let ban_btn = document.createElement("button");
  ban_btn.classList.add("btn", "btn-outline-danger", "ban");
  ban_btn.setAttribute("data-target", user_id);
  ban_btn.innerHTML = `
    <i class="fas fa-ban" aria-hidden="true"></i>
    Ban `;

  ban_btn.addEventListener("click", () => {
    banUser.call(ban_btn);
  });

  return ban_btn;
}

ban_btns.forEach((ban_btn) =>
  ban_btn.addEventListener("click", () => {
    banUser.call(ban_btn);
  })
);

unban_btns.forEach((unban_btn) =>
  unban_btn.addEventListener("click", () => {
    unbanUser.call(unban_btn);
  })
);

function banUser() {
  let id = this.getAttribute("data-target");
  let unban_btn = getUnbanBtn(id);
  let element = this;

  let init = {
    method: "PUT",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]').content,
    },
  };

  fetch(`/admin/banUser/${id}`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then((data) => {
          if ("message" in data) {
            alert(response["message"]);
          } else {
            console.log(data);
            element.replaceWith(unban_btn);
            unban_btn.parentNode.parentNode
              .querySelector('td[data-label = "Status"]')
              .replaceWith(getBannedStatus());
          }
        });
      } else {
        console.log("Network response was not ok." + JSON.stringify(data));
      }
    })
    .catch(function (error) {
      console.log(
        "There has been a problem with your fetch operation: " + error.message
      );
    });
}

function unbanUser() {
  let id = this.getAttribute("data-target");
  let ban_btn = getBanBtn(id);
  let element = this;
  let init = {
    method: "PUT",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]').content,
    },
  };
  fetch(`/admin/unbanUser/${id}`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then((data) => {
          if ("message" in data) {
            alert(response["message"]);
          } else {
            console.log(data);
            element.replaceWith(ban_btn);
            ban_btn.parentNode.parentNode
              .querySelector('td[data-label = "Status"]')
              .replaceWith(getUnBannedStatus());
          }
        });
      } else {
        console.log("Network response was not ok." + JSON.stringify(data));
      }
    })
    .catch(function (error) {
      console.log(
        "There has been a problem with your fetch operation: " + error.message
      );
    });
}

function getUserRow(user) {
  let tr = document.createElement("tr");

  /*username */
  let td_username = document.createElement("td");
  td_username.setAttribute("data-label", "User");
  td_username.innerHTML = `
    <img src= "/assets/avatars/${user["photo_path"]}.png" alt="profile picture" />
    <a href="#" class="user-link">${user["username"]}</a>
  `;

  /*date */
  let date = new Date(user["creation_date"]).toString();
  let separator = date.split(" ");
  let td_date = document.createElement("td");
  td_date.classList.add("text-center");
  td_date.setAttribute("data-label", "Created");
  td_date.innerHTML = `
    ${separator[2]} ${separator[1]}  ${separator[3]}
  `;

  /*status */
  let status = user["is_banned"] ? "banned" : "normal";
  let td_status = document.createElement("td");
  td_status.setAttribute("data-label", "Status");
  td_status.classList.add("align-center");
  if (status === "normal") {
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
  let td_email = document.createElement("td");
  td_email.classList.add("text-center");
  td_email.setAttribute("data-label", "Email");
  td_email.innerHTML = `
  <a href="#"> ${user["email"]}</a>
  `;

  /*button */
  let user_id = user["id"];
  let td_button = document.createElement("td");
  td_button.classList.add("text-center");
  let tdbutton = user["is_banned"] ? getUnbanBtn(user_id) : getBanBtn(user_id);
  td_button.appendChild(tdbutton);

  tr.appendChild(td_username);
  tr.appendChild(td_date);
  tr.appendChild(td_status);
  tr.appendChild(td_email);
  tr.appendChild(td_button);

  return tr;
}

function getProjectRow(project) {
  let tr = document.createElement("tr");

  /*name */
  let td_name = document.createElement("td");
  td_name.setAttribute("data-label", "Project");
  td_name.innerHTML = `
    <a href="/projects/${project["id"]}" class="project-link">
      ${project["name"]}
    </a>
  `;

  /*date*/
  let td_date = document.createElement("td");
  td_date.setAttribute("data-label", "Created");
  let date = new Date(project["creation_date"]).toString();
  let separator = date.split(" ");
  td_date.innerHTML = `
    ${separator[2]} ${separator[1]}  ${separator[3]}
  `;

  /*status*/
  let status;
  let class_color;
  let today = new Date();
  if (project["finish_date"] === null || project["finish_date"] >= today) {
    status = "Active";
    class_color = "text-success";
  } else {
    status = "Inactive";
    class_color = "text-danger";
  }
  let td_status = document.createElement("td");
  td_status.setAttribute("data-label", "Status");
  td_status.classList.add("align-center");

  td_status.innerHTML = `
  <span class="badge ${class_color}">
    ${status}
  </span>
  `;

  const issues = project["nr_issues"];
  const open_issues = project["nr_open_issues"];
  let td_progress = document.createElement("td");
  td_progress.setAttribute("data-attribute", "Progress");
  let value = issues > 0 ? (issues - open_issues) / issues : 0;

  td_progress.innerHTML = `
  <div class="mb-2 progress" style="height: 5px;">
    <div class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="width: ${
      value * 100
    }%;"></div>
    </div>
    <div>
    Tasks Completed:
    <span class="text-inverse"> ${issues - open_issues} / ${issues}</span>
  </div>
  `;

  /*delete button */
  let td_button = document.createElement("td");
  td_button.classList.add("text-center", "delete-project");
  let btn = document.createElement("button");
  btn.classList.add("btn", "btn-outline-danger", "table-link");
  btn.setAttribute("data-project", project["id"]);
  btn.innerHTML = `
  <i class="fa fa-trash"></i> 
  Delete
  `;
  btn.addEventListener("click", () => deleteProject.call(btn));

  td_button.appendChild(btn);

  /** join everything */

  tr.appendChild(td_name);
  tr.appendChild(td_date);
  tr.appendChild(td_status);
  tr.appendChild(td_progress);
  tr.appendChild(td_button);

  return tr;
}

function renderUsers(users) {
  const info_users = document.querySelector("#users tbody");

  while (info_users.firstChild) {
    info_users.removeChild(info_users.firstChild);
  }

  users.forEach((user) => {
    info_users.appendChild(getUserRow(user));
  });
}

function renderProjects(projects) {
  const info_projects = document.querySelector("#projects tbody");

  while (info_projects.firstChild) {
    info_projects.removeChild(info_projects.firstChild);
  }

  projects.forEach((project) => {
    info_projects.appendChild(getProjectRow(project));
  });
}

delete_project.forEach((delete_btn) =>
  delete_btn.addEventListener("click", function () {
    deleteProject.call(delete_btn);
  })
);

function deleteProject() {
  let id = this.getAttribute("data-project");
  let element = this;
  let init = {
    method: "DELETE",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]').content,
    },
  };
  fetch(`/admin/project/${id}`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then((data) => {
          if ("message" in data) {
            alert(response["message"]);
          } else {
            console.log(data);
            element.parentNode.parentNode.remove();
          }
        });
      } else {
        console.log("Network response was not ok." + JSON.stringify(data));
      }
    })
    .catch(function (error) {
      console.log(
        "There has been a problem with your fetch operation: " + error.message
      );
    });
}
