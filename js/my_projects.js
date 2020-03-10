const filter_sidebar = document.querySelector('#side-filter-container');
const close_filter_sidebar = document.querySelector('.close-side-issue');
const page_wrapper = document.querySelector('.page-wrapper');

close_filter_sidebar.addEventListener('click', event => {
  event.preventDefault();
  page_wrapper.classList.toggle('is-collapsed-right');
  filter_sidebar.classList.toggle('d-none');
});

const active_button = document.querySelector('#tables-types > li:nth-child(1)');
const finished_button = document.querySelector(
  '#tables-types > li:nth-child(2)'
);

active_button.addEventListener('click', event => {
  event.preventDefault();

  const active_list = document.querySelector('div.p-2:nth-child(4)');
  if (active_list.classList.contains('d-none')) {
    const finished_list = document.querySelector('div.p-2:nth-child(5)');

    active_list.classList.remove('d-none');
    finished_list.classList.add('d-none');
    active_button.classList.add('active');
    finished_button.classList.remove('active');
  }
});

finished_button.addEventListener('click', event => {
  event.preventDefault();
  const finished_list = document.querySelector('div.p-2:nth-child(5)');
  if (finished_list.classList.contains('d-none')) {
    const active_list = document.querySelector('div.p-2:nth-child(4)');

    finished_list.classList.remove('d-none');
    active_list.classList.add('d-none');

    active_button.classList.remove('active');
    finished_button.classList.add('active');
  }
});
