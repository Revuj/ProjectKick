const users_button = document.querySelector('#tables-types > li:nth-child(1)');
const projects_button = document.querySelector(
  '#tables-types > li:nth-child(2)'
);

users_button.addEventListener('click', event => {
  event.preventDefault();

  const user_list = document.querySelector('div.card:nth-child(1)');
  if (user_list.classList.contains('d-none')) {
    const projects_list = document.querySelector('div.card:nth-child(2)');
    const user_table = document.querySelector(
      '#tables-types > li:nth-child(1)'
    );
    const projects_table = document.querySelector(
      '#tables-types > li:nth-child(2)'
    );

    user_list.classList.remove('d-none');
    projects_list.classList.add('d-none');
    user_table.classList.add('active');
    projects_table.classList.remove('active');
  }
});

projects_button.addEventListener('click', event => {
  event.preventDefault();

  const projects_list = document.querySelector('div.card:nth-child(2)');
  if (projects_list.classList.contains('d-none')) {
    const user_list = document.querySelector('div.card:nth-child(1)');
    const user_table = document.querySelector(
      '#tables-types > li:nth-child(1)'
    );
    const projects_table = document.querySelector(
      '#tables-types > li:nth-child(2)'
    );

    projects_list.classList.remove('d-none');
    user_list.classList.add('d-none');

    user_table.classList.remove('active');
    projects_table.classList.add('active');
  }
});
