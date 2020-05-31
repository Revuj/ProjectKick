/**global variables **/
let create_list_btn = document.querySelector(".add-list");
let kanban_table = document.querySelector(".kanban-table");
let list_to_add_name = document.querySelector(".listCreated");
let delete_list_button = document.querySelector("#delete-list-button");
let delete_issue_button = document.querySelector("#delete-issue-button");
let edit_item_buttons = document.querySelectorAll(".edit-task");
let save_edit_item = document.querySelector("#edit-task-button");
let side_issue_header = document.querySelector("#side-issue-header");
let closeSideIssueButton = document.querySelector(".close-side-issue");
let addIssueButtons = document.getElementsByClassName("add-issue");

let list_items = document.querySelectorAll(".task-item");
let lists = document.querySelectorAll(".task-items");

const error_color = "red";
const success_color = "green";

let dragging = null;

/*function calls*/
dragDrop();

/*add event listeners */
create_list_btn.addEventListener("click", () => {
  if (is_input_empty(list_to_add_name)) {
    changecolors("error", list_to_add_name);
    return;
  }

  let id = document.getElementById("project-name").dataset.project;
  let url = `/api/projects/${id}/list`;
  sendAjaxRequest("post", url, { 'name': list_to_add_name.value }, createListHandler);
});

function createListHandler() {
  const response = JSON.parse(this.responseText);
  console.log(response)

  let newList = document.createElement("div");
  newList.className = "bd-highlight task";
  newList.id = `task-list-${list_to_add_name.value}`;
  newList.innerHTML = `              
		<div class="task-list-title d-flex align-items-center py-0">
			<h6 class="mr-auto my-0 text-left p-3"><i class="fa fa-fw fa-caret-right"></i>${list_to_add_name.value}</h6>
      <button class="btn mx-4 p-0 order-3" data-toggle="collapse" data-target="#add-item-${list_to_add_name.value}" aria-expanded="false" aria-controls="add-item">
      <i class="fas fa-plus"></i>
      </button>
      <button type="button" class="btn" data-toggle="modal" data-target="#delete-list-modal" data-list-id="task-list-${list_to_add_name.value}">
        <i class="fas fa-trash-alt"></i>
      </button>
		</div>
    <ul class="task-items">
      <li class="add-item-li collapse" id="add-item-${list_to_add_name.value}">
      <form class="add-item-form form-group">
        <div class="form-group text-left">
          <label for="item-title">Title</label>
          <input type="text" class="form-control" id="item-title" aria-describedby="emailHelp" placeholder="">
        </div>
        <div class="d-flex justify-content-between">
          <button type="submit" class="btn btn-primary add-item btn">Submit</button>
          <button type="reset" class="btn btn-primary cancel-add-item">Cancel</button>
        </div>
      </form>
      </li>
		</ul>`;

  kanban_table.appendChild(newList);
  document.getElementById("add-list-form").reset();
  let addItemButtons = document.querySelectorAll(".task-items button");
  listenAddItem(addItemButtons[addItemButtons.length - 2]);
  listenCancelAddItem(addItemButtons[addItemButtons.length - 1]);

  newList.addEventListener("dragover", function (e) {
    e.preventDefault();
  });

  newList.addEventListener("dragenter", function (e) {
    e.preventDefault();
  });

  newList.children[1].addEventListener("drop", function (e) {
    console.log(newList);
    this.append(draggedItem);
  });
}

let issue = null;
function listenAddItem(elem) {
  elem.addEventListener("click", event => {
    event.preventDefault();
    event.stopPropagation();
    let title =
      elem.parentElement.previousElementSibling.lastElementChild.value;
    issue = elem;
    let author = document.getElementById("auth-username").dataset.id;
    let liForm = issue.parentElement.parentElement.parentElement;
    let list = liForm.id.split("-").splice(-1)[0];
    let url = `/api/issues`;
    console.log({ title, author, list })
    $(`#${liForm.getAttribute("id")}`).collapse("toggle");
    sendAjaxRequest("post", url, { title, author, list, 'description': "" }, createIssueHandler);
  });
}

function createIssueHandler() {
  console.log(this.responseText)
  const response = JSON.parse(this.responseText);
  console.log(response);
  let id = response[0]['id'];
  let title = response[0]['name'];
  let username = response[1]['username'];
  let liForm = issue.parentElement.parentElement.parentElement;
  let list = liForm.parentElement;
  let newItem = document.createElement("li");
  newItem.id = id;
  newItem.className = "task-item text-left";
  newItem.setAttribute("draggable", "true");
  newItem.innerHTML = `<span class="d-flex flex-row align-items-center ml-2 row-1"> <h6 class="mb-0 py-2 task-title">${title}</h6>
  <button type="button" class="btn ml-auto d-none edit-task"><i class="fas fa-pencil-alt float-right"></i></button>
    <span class="issue-description d-none"></span>
    <span class="issue-due-date d-none">none</span>
    </span>
    <span class="d-flex flex-row align-items-center mx-2 row-2">
      <p class="w-100 mb-2"><span class="list-item-counter">#${id}</span> <span class="list-item-creator"> opened by
      <span class="author-reference">${username}</span></span></p>
    </span>`;

  list.insertBefore(newItem, liForm);
  newItem.setAttribute("draggable", true);
  setDraggable(newItem);
  openSideIssueListen(newItem);
  mouseOverListItem(newItem);
  mouseLeaveListItem(newItem);
  issue.parentElement.previousElementSibling.lastElementChild.value = "";
}

function listenCancelAddItem(elem) {
  elem.addEventListener("click", event => {
    let liForm = elem.parentElement.parentElement.parentElement;
    $(`#${liForm.getAttribute("id")}`).collapse("toggle");
  });
}

/* Allows modal to know which list to delete */
$("#delete-list-modal").on("show.bs.modal", function (event) {
  let button = $(event.relatedTarget); // Button that triggered the modal
  let recipient = button.data("list-id"); // Extract info from data-* attributes
  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
  let modal = $(this);
  modal.find(".modal-title").text("Delete " + recipient.substring(10));
  document
    .getElementById("delete-list-button")
    .setAttribute("data-list-id", recipient);
});

/* Delete List */
delete_list_button.addEventListener("click", event => {
  let list_id = delete_list_button.getAttribute("data-list-id");
  let list = document.getElementById(list_id);
  list.parentElement.removeChild(list);

  let id = document.getElementById("project-name").dataset.project;
  let url = `/api/projects/${id}/list`;
  list_id = list_id.split("-").slice(-1)[0];
  console.log({ list_id })
  sendAjaxRequest("delete", url, { 'list': list_id }, null);
});

/* Delete Issue */
delete_issue_button.addEventListener("click", event => {
  let issue_id = delete_issue_button.getAttribute("data-issue-id");
  let url = `/api/issues/${issue_id}`;
  console.log({ issue_id })
  sendAjaxRequest("delete", url, { 'issue': issue_id }, deleteIssueHandler);
  pageWrapper.classList.toggle("is-collapsed-right");
});

function deleteIssueHandler() {
  const response = JSON.parse(this.responseText);
  console.log(response);
  let issue_id = response['id'];
  let issue = document.getElementById(issue_id);
  issue.parentElement.removeChild(issue);
}

function setDraggable(elem) {
  elem.addEventListener("dragstart", function (e) {
    e.stopPropagation();
    console.log(elem);

    draggedItem = elem;
    setTimeout(function () {
      elem.style.display = "none";
    }, 0);
  });

  elem.addEventListener("dragend", function (e) {
    setTimeout(function () {
      draggedItem.style.display = "block";
      draggedItem = null;
    }, 0);
  });

  lists = document.querySelectorAll(".task-items");
  for (let j = 0; j < lists.length; j++) {
    const list = lists[j];

    list.addEventListener("dragover", function (e) {
      e.preventDefault();
    });

    list.addEventListener("dragenter", function (e) {
      e.preventDefault();
    });

    list.addEventListener("drop", function (e) {
      console.log("oi");
      console.log(this);
      this.append(draggedItem);
    });
  }
}

function dragDrop() {
  for (let i = 0; i < list_items.length; i++) {
    setDraggable(list_items[i]);
  }
}

/* Edit Task Label */
[...edit_item_buttons].forEach(elem =>
  elem.addEventListener("click", event => {
    let label = elem.previousElementSibling;
  })
);

save_edit_item.addEventListener("click", event => {
  let newLabel = document.getElementById("edit-task-label").value;
  let dataTaskLabel = save_edit_item.getAttribute("data-task-id");
  let taskToEdit = document.getElementById(`${dataTaskLabel}`);
  taskToEdit.querySelector(".task-title").innerHTML = newLabel;
});

function mouseOverListItem(elem) {
  elem.addEventListener("mouseover", event => {
    elem.querySelector(".edit-task").classList.remove("d-none");
  });
}

function mouseLeaveListItem(elem) {
  elem.addEventListener("mouseleave", event => {
    elem.querySelector(".edit-task").classList.add("d-none");
  });
}

function openSideIssueListen(elem) {
  elem.addEventListener("click", function () {
    let taskID = elem.getAttribute("id");
    let taskTitle = elem.querySelector(".task-title").innerHTML;
    let authorName = elem.querySelector(".author-reference").innerHTML;
    let description = elem.querySelector(".issue-description").innerHTML;
    let dueDate = elem.querySelector(".issue-due-date").innerHTML;
    let assignees = elem.querySelectorAll(".assignee");
    let labels = elem.querySelectorAll(".list-item-label");
    if (pageWrapper.classList.contains("is-collapsed-right")) {
      title.classList.remove("d-none");
      editTitleForm.classList.add("d-none");
      side_issue_header.querySelector("p").classList.remove("d-none");
      if (taskID !== sideIssue.getAttribute("data-task-id")) {
        sideIssue.setAttribute("data-task-id", taskID);
        sideIssue.querySelector(".task-title").innerHTML = taskTitle;
        sideIssue.querySelector("#issue-author").innerHTML = authorName;
        sideIssue.querySelector("#issue-description").innerHTML = description;
        sideIssue.querySelector("#due-date").innerHTML = dueDate;
      } else {
        pageWrapper.classList.toggle("is-collapsed-right");
      }
    } else {
      sideIssue.setAttribute("data-task-id", taskID);
      sideIssue.querySelector(".task-title").innerHTML = taskTitle;
      sideIssue.querySelector("#issue-author").innerHTML = authorName;
      sideIssue.querySelector("#issue-description").innerHTML = description;
      sideIssue.querySelector("#due-date").innerHTML = dueDate;
      pageWrapper.classList.toggle("is-collapsed-right");
    }
    delete_issue_button.dataset.issueId = taskID;

    let sideBarAssignees = document.querySelector(".assignees");
    sideBarAssignees.innerHTML = "";
    assignees.forEach(elem => {
      sideBarAssignees.innerHTML += `
      <li class="mr-2">
        ${elem.innerHTML}
      </li>
      `;
    });
    sideBarAssignees.innerHTML += `
    <li>
      <button
        id="add-assignee"
        type="button"
        class="custom-button add-button add-assignee"
      >
        <i class="fas fa-plus"></i>
      </button>
    </li>`

    let existingUsers = document.getElementsByClassName("existing-user-container");
    console.log(existingUsers)
    let userIds = [...assignees].map(elem => elem.dataset.userId);
    console.log(userIds);
    [...existingUsers].forEach(elem => {
      if (userIds.includes(elem.dataset.userId)) {
        elem.querySelector(".selected-user").style.visibility = "visible";
        elem.querySelector(".remove-user").style.visibility = "visible";
      } else {
        elem.querySelector(".selected-user").style.visibility = "hidden";
        elem.querySelector(".remove-user").style.visibility = "hidden";
      }
    });

    let sideBarLabels = document.querySelector(".labels");
    sideBarLabels.innerHTML = "";
    labels.forEach(elem => {
      sideBarLabels.innerHTML += `
      <li class="mr-2">
        <h6 class="mb-0 p-1 list-item-label bg-info">
          ${elem.innerHTML}
        </h6>
      </li>
      `;
    });
    sideBarLabels.innerHTML += `
    <li>
      <button
        id="add-label"
        type="button"
        class="custom-button add-button add-label"
      >
        <i class="fas fa-plus"></i>
      </button>
    </li>
    `

    let existingLabels = document.getElementsByClassName("existing-label-container");
    let labelIds = [...labels].map(elem => elem.dataset.labelId);
    [...existingLabels].forEach(elem => {
      if (labelIds.includes(elem.dataset.labelId)) {
        elem.querySelector(".selected-label").style.visibility = "visible";
        elem.querySelector(".remove-label").style.visibility = "visible";
      } else {
        elem.querySelector(".selected-label").style.visibility = "hidden";
        elem.querySelector(".remove-label").style.visibility = "hidden";
      }
    });

    let addNewLabelContainer = document.getElementById("add-new-label");
    addNewLabelContainer.classList.add("d-none")
    let addLabelBtn = document.getElementById("add-label");
    addLabelBtn.addEventListener("click", () => {
      addNewLabelContainer.classList.toggle("d-none");
    })

    let addNewAssigneeContainer = document.getElementById("add-new-assignee");
    addNewAssigneeContainer.classList.add("d-none")
    let addAssigneeBtn = document.getElementById("add-assignee");
    addAssigneeBtn.addEventListener("click", () => {
      addNewAssigneeContainer.classList.toggle("d-none")
    })

    document.getElementById("select-due-date").classList.add("d-none");
  });
}

console.log(document.querySelectorAll(".task-item"));

/* Show edit button when item is hovered */
[...list_items].forEach(elem => mouseOverListItem(elem));

[...list_items].forEach(elem => mouseLeaveListItem(elem));

/* Side Issue Related */
let sideIssue = document.querySelector("#side-issue");
let sideIssueButtons = document.querySelectorAll(".task-item");
let pageWrapper = document.querySelector(".page-wrapper");
let title = side_issue_header.querySelector(".task-title");
let editTitleForm = side_issue_header.querySelector(".edit-issue-title-form");
let cancelEditTitleButton = side_issue_header.querySelector(
  ".edit-item-title-cancel"
);

mouseOverListItem(side_issue_header);
mouseLeaveListItem(side_issue_header);

side_issue_header
  .querySelector(".edit-task")
  .addEventListener("click", event => {
    editTitleForm.querySelector("input").value = title.innerHTML;
    title.classList.toggle("d-none");
    editTitleForm.classList.toggle("d-none");
    side_issue_header.querySelector("p").classList.toggle("d-none");
  });

closeSideIssueButton.addEventListener("click", event => {
  pageWrapper.classList.toggle("is-collapsed-right");
  title.classList.remove("d-none");
  editTitleForm.classList.add("d-none");
  side_issue_header.querySelector("p").classList.remove("d-none");
  document.getElementById("add-new-label").classList.add("d-none");
  document.getElementById("select-due-date").classList.add("d-none");
});

cancelEditTitleButton.addEventListener("click", event => {
  title.classList.toggle("d-none");
  editTitleForm.classList.toggle("d-none");
  side_issue_header.querySelector("p").classList.toggle("d-none");
});

[...sideIssueButtons].forEach(elem => openSideIssueListen(elem));

// Add Label
let addNewLabelContainer = document.getElementById("add-new-label");
let addLabelBtn = document.getElementById("add-label");
addLabelBtn.addEventListener("click", () => {
  addNewLabelContainer.classList.toggle("d-none")
})

// Add Assignee
let addNewAssigneeContainer = document.getElementById("add-new-assignee");
let addAssigneeBtn = document.getElementById("add-assignee");
addAssigneeBtn.addEventListener("click", () => {
  addNewAssigneeContainer.classList.toggle("d-none")
})

// Add Due Date
const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Augt', 'Sep', 'Oct', 'Nov', 'Dec'];
let selectDueDateContainer = document.getElementById("select-due-date");
let selectDueDateBtn = document.getElementById("change-due-date");
let submitDueDateBtn = document.getElementById("submit-due-date");
let newDueDate = document.getElementById("new-due-date");
let dueDate = document.getElementById("due-date");

selectDueDateBtn.addEventListener("click", () => {
  selectDueDateContainer.classList.toggle("d-none")
})

submitDueDateBtn.addEventListener("click", () => {
  selectDueDateContainer.classList.toggle("d-none")
  let due_date = newDueDate.value;
  let id = delete_issue_button.dataset.issueId;
  let url = `/api/issues/${id}`;
  sendAjaxRequest("put", url, { due_date }, changeDueDateHandler);
})

function changeDueDateHandler() {
  const response = JSON.parse(this.responseText);
  console.log(response);
  let date = response['due_date'].split("-");
  let year = date[0];
  let month = months[parseInt(date[1]) - 1];
  let day = parseInt(date[2]).toString();
  dueDate.innerHTML = month + " " + day + " " + year;
  console.log(dueDate);
}

// Edit Title
let submitTitle = document.querySelector(".edit-item-title");
submitTitle.addEventListener("click", (event) => {
  event.preventDefault();
  let title = document.getElementById("new-task-title").value;
  let id = delete_issue_button.dataset.issueId;
  let url = `/api/issues/${id}`;
  sendAjaxRequest("put", url, { title }, changeTitleHandler);
})

function changeTitleHandler() {
  const response = JSON.parse(this.responseText);
  let newTitle = response['name'];
  document.querySelector("#side-issue-container .task-title").innerHTML = newTitle;
  title.classList.toggle("d-none");
  editTitleForm.classList.toggle("d-none");
  side_issue_header.querySelector("p").classList.toggle("d-none");
  document.getElementById(response['id']).querySelector('.task-title').innerHTML = newTitle;
}


/*general functions */

function is_input_empty(input) {
  return input.value === "";
}

function clear_input(input) {
  input.value = "";
}

function change(item, color) {
  item.style.backgroundColor = color;
}

function changecolors(type_message, item) {
  let color;
  if (type_message === "error") {
    color = error_color;
  } else if (type_message === "success") {
    color = sucess_color;
  }

  item.style.backgroundColor = color;

  setTimeout(change.bind(null, item, "#fff"), 1000);
}

/*========================  FILTERS ==================================*/
const input_filter = document.querySelector("#filter-issues");

input_filter.addEventListener("input", e => {
  filterTasks(tasks_list, e.target.value);
});


function filterTasks(task_list, value) {
  let filtered = [];

  task_list.forEach(task => {
    // for each board

    let element = { name: task.name };

    element.tasks = task.tasks.filter(element => {
      // for each task
      const regex = new RegExp(`^${value}`, "gi");

      // filter creator
      if (element.creator.match(regex)) return true;

      //filter title
      if (element.title.match(regex)) return true;

      // filter by tags
      let tags = element.tags;
      for (let i = 0; i < tags.length; i++) {
        if (tags[i].match(regex)) return true;
      }
      return false;
    });

    filtered.push(element);
  });

  kanban_table.innerHTML = outputKanbanHTML(filtered);
  let list_items = document.querySelectorAll(".task-item");
  [...list_items].forEach(elem => {
    mouseOverListItem(elem);
    mouseLeaveListItem(elem);
    setDraggable(elem);
  });
}


list_items = document.getElementsByClassName("task-item");
[...list_items].forEach(elem => {
  mouseOverListItem(elem);
  mouseLeaveListItem(elem);
  setDraggable(elem);
});
let add_item_button = document.querySelectorAll(".add-item");
let cancel_add_item_button = document.querySelectorAll(".cancel-add-item");
[...add_item_button].forEach(elem => listenAddItem(elem));
[...cancel_add_item_button].forEach(elem => listenCancelAddItem(elem));
