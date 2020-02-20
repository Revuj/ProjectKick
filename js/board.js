/**global variables **/
let create_list_btn = document.querySelector(".add-list");
let kanban_table = document.querySelector(".kanban-table");
let list_to_add_name = document.querySelector(".listCreated");
let add_item_button = document.querySelectorAll(".add-item");
let cancel_add_item_button = document.querySelectorAll(".cancel-add-item");
let delete_list_button = document.querySelector("#delete-list-button");

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
      <li class="task-item collapse" id="add-item-${list_to_add_name.value}">
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

  // let item = document.createElement("li");
  // item.innerHTML = list_to_add_name.value;
  // item.className += " task-item ml-3 hover-effect";
  // item.setAttribute("draggable", true);

  // item.addEventListener("dragstart", function(e) {
  //   draggedItem = item;
  //   setTimeout(function() {
  //     item.style.display = "none";
  //   }, 0);
  // });

  // item.addEventListener("dragend", function(e) {
  //   setTimeout(function() {
  //     draggedItem.style.display = "block";
  //     draggedItem = null;
  //   }, 0);
  // });

  // backlog_items.appendChild(item);
  // clear_input(list_to_add_name);
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
    newItem.className = "task-item hover-effect";
    newItem.setAttribute("draggable", "true");
    newItem.innerHTML = title;
    list.insertBefore(newItem, liForm);
    $(`#${liForm.getAttribute("id")}`).collapse("toggle");
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

function dragDrop() {
  for (let i = 0; i < list_items.length; i++) {
    const item = list_items[i];

    item.addEventListener("dragstart", function(e) {
      draggedItem = item;
      setTimeout(function() {
        item.style.display = "none";
      }, 0);
    });

    item.addEventListener("dragend", function(e) {
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
        this.append(draggedItem);
      });
    }
  }
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
