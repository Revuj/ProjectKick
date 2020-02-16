
/**global variables **/
let create_task_btn = document.querySelector('.add-to-backlog')
let backlog_items = document.querySelector('.backlog .task-items')
let task_to_add_name = document.querySelector('.listCreated')

const list_items = document.querySelectorAll('.task-item')
const lists = document.querySelectorAll('.task-items')

const error_color = "red"
const success_color = "green"


let dragging = null;

/*function calls*/
dragDrop()


/*add event listeners */
create_task_btn.addEventListener('click', () => {

	if (is_input_empty(task_to_add_name)) {
		changecolors('error', task_to_add_name)
		return
	}

	let item = document.createElement('li')
	item.innerHTML = task_to_add_name.value
	item.className += " task-item ml-3 hover-effect"
	item.setAttribute('draggable', true)

	item.addEventListener('dragstart', function (e) {
		draggedItem = item;
		setTimeout(function () {
			item.style.display = 'none';
		}, 0)
	});

	item.addEventListener('dragend', function (e) {
		setTimeout(function () {
			draggedItem.style.display = 'block';
			draggedItem = null;
		}, 0);
	})

	backlog_items.appendChild(item)
	clear_input(task_to_add_name)

})



function dragDrop() {

	for (let i = 0; i < list_items.length; i++) {
		const item = list_items[i];

		item.addEventListener('dragstart', function (e) {
			draggedItem = item;
			setTimeout(function () {
				item.style.display = 'none';
			}, 0)
		});

		item.addEventListener('dragend', function (e) {
			setTimeout(function () {
				draggedItem.style.display = 'block';
				draggedItem = null;
			}, 0);
			

		})

		for (let j = 0; j < lists.length; j ++) {
			const list = lists[j];

			list.addEventListener('dragover', function (e) {
				e.preventDefault();
			});
			
			list.addEventListener('dragenter', function (e) {
				e.preventDefault();
			});

			list.addEventListener('drop', function (e) {
				this.append(draggedItem);
			});
		}
	}

}


/*general functions */

function is_input_empty(input) {
	return input.value === ''
}

function clear_input(input) {
	input.value = ''
}

function change(item, color) {
	item.style.backgroundColor = color
}

function changecolors(type_message, item) {

	let color;
	if (type_message === 'error') {
		color = error_color
	}
	else if (type_message === 'success') {
		color = sucess_color
	}
	
	item.style.backgroundColor = color

	setTimeout(change.bind(null, item, '#fff'), 1000)

}





