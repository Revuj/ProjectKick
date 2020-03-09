const task_list = document.querySelector('div.col:nth-child(2)');
const project = document.querySelector('div.col:nth-child(1)');

project.addEventListener('change', event => {
  event.preventDefault();
  const input = project.querySelector('input');
  if (!input.value.length) {
    task_list.classList.add('d-none');
  } else {
    task_list.classList.remove('d-none');
  }
});