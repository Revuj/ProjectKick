const filter_button = document.querySelector('.show-on-click');
const filter_sidebar = document.querySelector('#side-filter-container');
const close_filter_sidebar = document.querySelector('.close-side-issue');
const page_wrapper = document.querySelector(".page-wrapper");

filter_button.addEventListener("click", event => {
  event.preventDefault();
  filter_sidebar.classList.remove("d-none");
});

close_filter_sidebar.addEventListener("click", event => {
  event.preventDefault();
  page_wrapper.classList.toggle("is-collapsed-right");
  filter_sidebar.classList.toggle("d-none");
});

const tags_input = document.querySelector('#project_tags');

tags_input.addEventListener('submit', event => {
  console.log("oi");
  event.preventDefault();
  const tags_container = document.querySelector('.modal-body > form:nth-child(1) > div:nth-child(3)');
  let tag = document.createElement('span');
  tags_container.appendChild(tag);
})