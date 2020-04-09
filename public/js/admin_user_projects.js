const users_button = document.querySelector('#tables-types > li:nth-child(1)');
const projects_button = document.querySelector(
  '#tables-types > li:nth-child(2)'
);

users_button.addEventListener('click', event => {
  event.preventDefault();

  const user_list = document.querySelector('#users');
  if (user_list.classList.contains('d-none')) {
    const projects_list = document.querySelector('#projects');

    user_list.classList.remove('d-none');
    projects_list.classList.add('d-none');
    users_button.classList.add('active');
    projects_button.classList.remove('active');
  }
});

projects_button.addEventListener('click', event => {
  event.preventDefault();

  const projects_list = document.querySelector('#projects');
  if (projects_list.classList.contains('d-none')) {
    const user_list = document.querySelector('#users');

    projects_list.classList.remove('d-none');
    user_list.classList.add('d-none');

    users_button.classList.remove('active');
    projects_button.classList.add('active');
  }
});
