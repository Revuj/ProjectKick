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

const today_button = document.querySelector('#tables-types > li:nth-child(1)');
const upcoming_button = document.querySelector(
  '#tables-types > li:nth-child(2)'
);

today_button.addEventListener('click', event => {
  event.preventDefault();

  const today_list = document.querySelector('#today');
  if (today_list.classList.contains('d-none')) {
    const upcoming_list = document.querySelector('#upcoming');

    today_list.classList.remove('d-none');
    upcoming_list.classList.add('d-none');
    today_button.classList.add('active');
    upcoming_button.classList.remove('active');
  }
});

upcoming_button.addEventListener('click', event => {
  event.preventDefault();
  const upcoming_list = document.querySelector('#upcoming');
  if (upcoming_list.classList.contains('d-none')) {
    const today_list = document.querySelector('#today');

    upcoming_list.classList.remove('d-none');
    today_list.classList.add('d-none');

    today_button.classList.remove('active');
    upcoming_button.classList.add('active');
  }
});
