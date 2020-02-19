/**global variables **/
let create_task_btn = document.querySelector(".add-list");
let kanban_table = document.querySelector(".kanban-table");
let list_to_add_name = document.querySelector(".listCreated");

const list_items = document.querySelectorAll(".task-item");
const lists = document.querySelectorAll(".task-items");

const error_color = "red";
const success_color = "green";

let dragging = null;

/*function calls*/
dragDrop();

/*add event listeners */
create_task_btn.addEventListener("click", () => {
  if (is_input_empty(list_to_add_name)) {
    changecolors("error", list_to_add_name);
    return;
  }

  let newList = document.createElement("div");
  newList.className = "bd-highlight task h-100";
  newList.innerHTML = `              
		<div class="task-title d-flex align-items-center py-0">
			<h6 class="mr-auto my-0 text-left p-3"><i class="fa fa-fw fa-caret-right"></i>${list_to_add_name.value}</h6>
			<i class="fas fa-plus order-3 mx-4"></i><i class="fas fa-trash-alt"></i>
		</div>
		<ul class="task-items">
		</ul>`;

  kanban_table.appendChild(newList);
  document.getElementById("add-list-form").reset();

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
