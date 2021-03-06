const comment = document.getElementById("new-comment");
const upvotes = document.querySelectorAll(".upvote");
const downvotes = document.querySelectorAll(".downvote");

upvotes.forEach((upvoteArrow) =>
  upvoteArrow.addEventListener("click", upvote.bind(upvoteArrow))
);
downvotes.forEach((downvoteArrow) =>
  downvoteArrow.addEventListener("click", downvote.bind(downvoteArrow))
);

function upvote() {
  const comment_id = this.parentNode.getAttribute("data-target");
  const upvote = 1;
  vote(comment_id, upvote, this);
}

function downvote() {
  const comment_id = this.parentNode.getAttribute("data-target");
  const upvote = -1;
  vote(comment_id, upvote, this);
}

const nth = function (d) {
  if (d > 3 && d < 21) return "th";
  switch (d % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
};

function createComment(comment, current_user) {
  console.log(comment.creation_date);
  let date = new Date(comment.creation_date.split("+")[0]);
  console.log(date);
  let h = date.getHours(),
    m = date.getMinutes();
  let _time = h > 12 ? h - 12 + ":" + m + "pm" : h + ":" + m + "am";

  let day_week = {
    0: "Sunday",
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Sathurday",
  };

  let months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  let time =
    _time +
    " on " +
    day_week[date.getDay()] +
    " " +
    date.getDate() +
    nth(date.getDate()) +
    " " +
    months[date.getMonth()] +
    " " +
    date.getFullYear();

  let new_comment = document.createElement("div");
  new_comment.classList.add(
    "comment",
    "d-flex",
    "border-bottom",
    "mt-4",
    "pb-1"
  );

  new_comment.innerHTML = `
    <img class="comment-author" src="/assets/avatars/${current_user["photo_path"]}.png" alt="${current_user["username"]} profile picture">

    <div class="comment-detail ml-3">
      <h6>
        <a href="/users/${current_user["id"]}"><span class="author-reference">${current_user["username"]}</span></a>
        <span class="comment-timestamp ml-1"> ${time}</span>
      </h6>
      <p>
        ${comment["content"]}
      </p>
  </div>`;

  let voting = document.createElement("div");
  voting.classList.add("karma", "ml-auto", "mr-3", "d-flex", "flex-column");
  voting.setAttribute("data-target", `${comment["id"]}`);

  let child1 = document.createElement("i");
  child1.classList.add("fas", "fa-chevron-up", "upvote");
  child1.setAttribute("aria-hidden", true);

  let child2 = document.createElement("p");
  child2.classList.add("mb-0", "text-center");
  child2.textContent = 0;

  let child3 = document.createElement("i");
  child3.classList.add("fas", "fa-chevron-down", "downvote");
  child1.setAttribute("aria-hidden", true);

  voting.appendChild(child1);
  voting.appendChild(child2);
  voting.appendChild(child3);

  new_comment.appendChild(voting);

  document.querySelector(".comments-container").prepend(new_comment);
  child1.addEventListener("click", upvote.bind(child1));
  child3.addEventListener("click", downvote.bind(child3));
}

async function makeComment() {
  const user_id = comment.getAttribute("data-user");
  const issue_id = comment.getAttribute("data-issue");
  const content = comment.value;

  let init = {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]').content,
    },
    body: encodeForAjax({ user_id, issue_id, content }),
  };

  fetch(`/api/issues/comment`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then((data) => {
          if ("errors" in data) {
            displayError(data);
          } else {
            console.log(data);
            console.log(data[0]);
            createComment(data[0], data[1]);
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

async function vote(comment_id, upvote, clickedArrow) {
  let init = {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]').content,
    },
    body: encodeForAjax({ comment_id, upvote }),
  };

  let value = clickedArrow.parentNode.querySelector("p");

  fetch(`/api/votes`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then((data) => {
          if ("errors" in data) {
            const error_message = data["errors"];
            const div_elem = document.getElementById("dialog");
            div_elem.classList.add("error-color");
            div_elem.querySelector(".content").textContent = error_message;
            div_elem.classList.remove("d-none");
            div_elem.classList.remove("success-color");
            clickedArrow.classList.remove("voted");
            const val = upvote === 1 ? -1 : 1;
            value.innerHTML = parseInt(value.innerHTML) + val;
            clearTime();
            timeout = setTimeout(() => {
              div_elem.classList.add("d-none");
              div_elem.querySelector(".content").textContent = "";
              div_elem.classList.remove("error-color");
            }, 3500);
          } else {
            if ("update" in data) {
              clickedArrow.parentNode
                .querySelector(".voted")
                .classList.remove("voted");
              clickedArrow.classList.add("voted");
              const val = upvote === 1 ? 2 : -2;
              console.log(val);
              value.innerHTML = parseInt(value.innerHTML) + val;
            } else if ("create" in data) {
              const val = upvote === 1 ? 1 : -1;
              value.innerHTML = parseInt(value.innerHTML) + val;
              clickedArrow.classList.add("voted");
              const dialog = document.getElementById("dialog");
              dialog.classList.remove("d-none");
              dialog.querySelector(".content").textContent = data["message"];
              dialog.classList.remove("error-color");
              dialog.classList.add("success-color");
              clearTime();
              timeout = setTimeout(() => {
                dialog.classList.add("d-none");
                dialog.querySelector(".content").textContent = "";
                dialog.classList.remove("success-color");
              }, 3500);
            }
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

comment.addEventListener("keypress", function (event) {
  if (event.keyCode === 13) {
    event.preventDefault();
    makeComment();
    comment.value = "";
  }
});

// Edit Issue
let editIssueBtn = document.getElementById("edit-issue");
let issueTitle = document.getElementById("issue-title");
let issueDescription = document.getElementById("issue-description");
let saveIssueBtn = document.getElementById("save-issue");
let editTitleInput = document.getElementById("edit-task-label");
let editDescriptionInput = document.getElementById("edit-task-description");

editIssueBtn.addEventListener("click", () => {
  saveIssueBtn.classList.toggle("d-none");
  editIssueBtn.classList.toggle("d-none");
  issueTitle.classList.toggle("d-none");
  issueDescription.classList.toggle("d-none");
  editTitleInput.value = issueTitle.innerHTML.trim();
  editDescriptionInput.value = issueDescription.innerHTML.trim();
  editTitleInput.classList.toggle("d-none");
  editDescriptionInput.classList.toggle("d-none");
});

saveIssueBtn.addEventListener("click", () => {
  editIssueBtn.classList.toggle("d-none");
  saveIssueBtn.classList.toggle("d-none");
  issueTitle.classList.toggle("d-none");
  issueDescription.classList.toggle("d-none");
  editTitleInput.classList.toggle("d-none");
  editDescriptionInput.classList.toggle("d-none");

  let title = editTitleInput.value.trim();
  let description = editDescriptionInput.value.trim();
  let id = saveIssueBtn.dataset.issueId;
  let url = `/api/issues/${id}`;
  sendAjaxRequest("put", url, { title, description }, editIssueHandler);
});

function editIssueHandler() {
  const response = JSON.parse(this.responseText);
  issueTitle.innerHTML = response["name"];
  issueDescription.innerHTML = response["description"];
}

// Open / Close Issue
let closeBtn = document.getElementById("close-button");
let issueStatus = document.getElementById("issue-status");

closeBtn.addEventListener("click", () => {
  closeBtn.classList.toggle("close-button");
  closeBtn.classList.toggle("open-button");
  let id = saveIssueBtn.dataset.issueId;
  let url = `/api/issues/${id}`;
  let status = null;

  if (issueStatus.innerHTML == "Open") {
    issueStatus.innerHTML = "Closed";
    issueStatus.classList.remove("bg-success");
    issueStatus.classList.add("bg-danger");
    status = "true";
  } else {
    issueStatus.innerHTML = "Open";
    issueStatus.classList.remove("bg-danger");
    issueStatus.classList.add("bg-success");
    status = "false";
  }

  sendAjaxRequest("put", url, { status }, null);
});

// Add Assignee
let addNewAssigneeContainer = document.getElementById("add-new-assignee");
let addAssigneeBtn = document.getElementById("add-assignee");
let newAssignee = document.getElementById("new-assignee");
let existingMembers = document.getElementsByClassName(
  "existing-user-container"
);

/* Search for Assignee */
newAssignee.addEventListener("keyup", () => {
  // ignores capitalization and spaces
  let filter = newAssignee.value.toUpperCase().replace(/\s/g, "");

  // only filters cars when input size has more than 2 characters
  if (filter.length < 3) {
    [...existingMembers].forEach((user) => {
      user.classList.add("d-flex");
      user.classList.remove("d-none");
    });
    return;
  }

  [...existingMembers].forEach((user) => {
    console.log(user.dataset.username.toUpperCase());
    if (
      user.dataset.username.toUpperCase().replace(/\s/g, "").indexOf(filter) !=
      -1
    ) {
      user.classList.add("d-flex");
      user.classList.remove("d-none");
    } else {
      user.classList.remove("d-flex");
      user.classList.add("d-none");
    }
  });
});

addAssigneeBtn.addEventListener("click", () => {
  addNewAssigneeContainer.classList.toggle("d-none");
});

[...existingMembers].forEach((elem) =>
  elem.addEventListener("click", () => {
    let selectedUser = elem.querySelector(".selected-user");
    selectedUser.classList.toggle("invisible");
    let id = addAssigneeBtn.dataset.issueId;
    let user = elem.dataset.userId;
    let url = `/api/issues/${id}/assign`;
    let sender = document.getElementById("auth-username").dataset.id;

    if (selectedUser.classList.contains("invisible")) {
      sendAjaxRequest("delete", url, { user }, deleteMemberHandler);
    } else {
      sendAjaxRequest("post", url, { user, sender }, addMemberHandler);
    }
  })
);

function addMemberHandler() {
  const response = JSON.parse(this.responseText);

  let newMember = document.createElement("li");
  newMember.className = "mr-2";
  newMember.innerHTML = `
    <img src="/assets/avatars/${response["photo_path"]}.png" alt=${response["username"]} draggable="false">
  `;
  newMember.dataset.userId = response["id"];

  let id = addAssigneeBtn.dataset.issueId;
  document.querySelector(".assignees").prepend(newMember);
}

function deleteMemberHandler() {
  const response = JSON.parse(this.responseText);
  document
    .querySelector(".assignees")
    .querySelector(`[data-user-id='${response.id}']`)
    .remove();
}

// Add Label
let addNewLabelContainer = document.getElementById("add-new-label");
let addLabelBtn = document.getElementById("add-label");
addLabelBtn.addEventListener("click", () => {
  addNewLabelContainer.classList.toggle("d-none");
});

function labelListen(elem) {
  elem.querySelector(".selected-label").classList.toggle("invisible");
  let selectedLabel = elem.querySelector(".selected-label");
  let id = addAssigneeBtn.dataset.issueId;
  let label = elem.dataset.labelId;
  let url = `/api/issues/${id}/label`;

  if (selectedLabel.classList.contains("invisible")) {
    sendAjaxRequest("delete", url, { label }, deleteLabelHandler);
  } else {
    sendAjaxRequest("post", url, { label }, addLabelHandler);
  }
}

let existingLabels = document.getElementsByClassName(
  "existing-label-container"
);
[...existingLabels].forEach((elem) =>
  elem.addEventListener("click", () => {
    labelListen(elem);
  })
);

function deleteLabelHandler() {
  const response = JSON.parse(this.responseText);
  let id = addAssigneeBtn.dataset.issueId;
  document
    .querySelector(".labels")
    .querySelector(`[data-label-id='${response.tag_id}']`)
    .remove();
}

function addLabelHandler() {
  const response = JSON.parse(this.responseText);
  let newLabel = document.createElement("li");
  newLabel.className = "mr-2";
  newLabel.innerHTML = `
  <h6 class="label mb-0 px-1 list-item-label bg-info p-1 text-white"> 
    ${response.name}
  </h6>
  `;

  newLabel.dataset.labelId = response["id"];

  let id = addAssigneeBtn.dataset.issueId;
  document.querySelector(".labels").prepend(newLabel);
}

// Create New Label
let labelForm = document.getElementById("write-label");
let newLabel = document.getElementById("new-label");

/* Search for Label */
newLabel.addEventListener("keyup", () => {
  // ignores capitalization and spaces
  let filter = newLabel.value.toUpperCase().replace(/\s/g, "");

  // only filters cars when input size has more than 2 characters
  if (filter.length < 3) {
    [...existingLabels].forEach((label) => {
      label.classList.add("d-flex");
      label.classList.remove("d-none");
    });
    return;
  }

  [...existingLabels].forEach((label) => {
    if (
      label.dataset.labelName
        .toUpperCase()
        .replace(/\s/g, "")
        .indexOf(filter) != -1
    ) {
      label.classList.add("d-flex");
      label.classList.remove("d-none");
    } else {
      label.classList.remove("d-flex");
      label.classList.add("d-none");
    }
  });
});

labelForm.addEventListener("submit", (event) => {
  event.preventDefault();
  let name = newLabel.value;
  let id = addAssigneeBtn.dataset.issueId;
  let url = `/api/issues/${id}/label`;

  sendAjaxRequest("post", url, { name }, createLabelHandler);
  newLabel.value = "";
});

function createLabelHandler() {
  const response = JSON.parse(this.responseText);

  if ("errors" in response) {
    displayError(response);
    return;
  }

  let newLabel = document.createElement("li");
  newLabel.className = "mr-2";
  newLabel.innerHTML = `
  <h6 class="label mb-0 px-1 list-item-label bg-info p-1 text-white"> 
    ${response.name}
  </h6>
  `;
  newLabel.dataset.labelId = response["id"];

  document.querySelector(".labels").prepend(newLabel);

  let existingLabel = document.createElement("li");
  existingLabel.className =
    "existing-label-container clickable d-flex flex-row align-items-center p-2";
  existingLabel.dataset.labelId = response["id"];
  existingLabel.dataset.labelName = response["name"];
  existingLabel.innerHTML = `
    <i class="fas fa-check selected-label mr-2" aria-hidden="true" ></i>
      <div class="color bg-info">
      </div>
      <h6 class="mb-0 p-1 existing-label">
        ${response.name}
      </h6>
  `;

  existingLabel.addEventListener("click", (elem) => labelListen(elem));
}
