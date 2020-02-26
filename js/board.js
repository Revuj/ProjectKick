/**global variables **/
let create_list_btn = document.querySelector(".add-list");
let kanban_table = document.querySelector(".kanban-table");
let list_to_add_name = document.querySelector(".listCreated");
let add_item_button = document.querySelectorAll(".add-item");
let cancel_add_item_button = document.querySelectorAll(".cancel-add-item");
let delete_list_button = document.querySelector("#delete-list-button");
let edit_item_buttons = document.querySelectorAll(".edit-task");
let save_edit_item = document.querySelector("#edit-task-button");

const list_items = document.querySelectorAll(".task-item");
const lists = document.querySelectorAll(".task-items");

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

  let newList = document.createElement("div");
  newList.className = "bd-highlight task h-100";
  newList.id = `task-list-${list_to_add_name.value}`;
  newList.innerHTML = `              
		<div class="task-title d-flex align-items-center py-0">
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

  newList.addEventListener("dragover", function(e) {
    e.preventDefault();
  });

  newList.addEventListener("dragenter", function(e) {
    e.preventDefault();
  });

  newList.children[1].addEventListener("drop", function(e) {
    console.log(newList);
    this.append(draggedItem);
  });
});

function listenAddItem(elem) {
  elem.addEventListener("click", event => {
    event.preventDefault();
    event.stopPropagation();
    let title =
      elem.parentElement.previousElementSibling.lastElementChild.value;
    let liForm = elem.parentElement.parentElement.parentElement;
    let list = liForm.parentElement;
    let newItem = document.createElement("li");
    // eventualmente este id deve vir da database (após a inserção com ajax)
    let id = Math.random()
      .toString(36)
      .substr(2, 9);
    newItem.id = id;
    newItem.className = "task-item text-left";
    newItem.setAttribute("draggable", "true");
    newItem.innerHTML = `<span class="d-flex flex-row align-items-center ml-2 row-1"> <h6 class="mb-0 py-2">${title}</h6>
    <button type="button" class="btn ml-auto d-none edit-task" data-toggle="modal" data-target="#edit-task-modal"
      data-task-id="${id}"><i class="fas fa-pencil-alt float-right"></i></button>
      </span>
      <span class="d-flex flex-row align-items-center mx-2 row-2">
        <p class="w-100 mb-2"><span class="list-item-counter">#3</span> <span class="list-item-creator"> opened by
            Revuj</span></p>
      </span>`;
    list.insertBefore(newItem, liForm);
    $(`#${liForm.getAttribute("id")}`).collapse("toggle");
    newItem.setAttribute("draggable", true);
    setDraggable(newItem);
    mouseOverListItem(newItem);
    mouseLeaveListItem(newItem);
    elem.parentElement.previousElementSibling.lastElementChild.value = "";
  });
}

[...add_item_button].forEach(elem => listenAddItem(elem));

function listenCancelAddItem(elem) {
  elem.addEventListener("click", event => {
    let liForm = elem.parentElement.parentElement.parentElement;
    $(`#${liForm.getAttribute("id")}`).collapse("toggle");
  });
}

[...cancel_add_item_button].forEach(elem => listenCancelAddItem(elem));

/* Allows modal to know which list to delete */
$("#delete-list-modal").on("show.bs.modal", function(event) {
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
});

function setDraggable(elem) {
  elem.addEventListener("dragstart", function(e) {
    draggedItem = elem;
    setTimeout(function() {
      elem.style.display = "none";
    }, 0);
  });

  elem.addEventListener("dragend", function(e) {
    setTimeout(function() {
      draggedItem.style.display = "block";
      draggedItem = null;
    }, 0);
  });

  for (let j = 0; j < lists.length; j++) {
    const list = lists[j];

    list.addEventListener("dragover", function(e) {
      e.preventDefault();
    });

    list.addEventListener("dragenter", function(e) {
      e.preventDefault();
    });

    list.addEventListener("drop", function(e) {
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

$("#edit-task-modal").on("show.bs.modal", function(event) {
  var button = $(event.relatedTarget); // Button that triggered the modal
  var recipient = button.data("task-id"); // Extract info from data-* attributes
  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
  var modal = $(this);
  var taskItem = document.querySelector(`.task-item[id="${recipient}"]`);
  var label = taskItem.children[0].innerHTML;
  modal.find(".modal-body input").val(label);
  document
    .getElementById("edit-task-button")
    .setAttribute("data-task-id", recipient);
});

save_edit_item.addEventListener("click", event => {
  let newLabel = document.getElementById("edit-task-label").value;
  let dataTaskLabel = save_edit_item.getAttribute("data-task-id");
  console.log(dataTaskLabel);
  let taskToEdit = document.getElementById(`${dataTaskLabel}`);
  console.log(taskToEdit);
  taskToEdit.children[0].innerHTML = newLabel;
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

/* Show edit button when item is hovered */
[...list_items].forEach(elem => mouseOverListItem(elem));

[...list_items].forEach(elem => mouseLeaveListItem(elem));

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
