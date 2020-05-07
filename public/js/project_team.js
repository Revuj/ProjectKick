const developer_button = document.querySelector(
  '#tables-types > li:nth-child(1)'
);
const coordinator_button = document.querySelector(
  '#tables-types > li:nth-child(2)'
);

const all_button = document.querySelector(
  '#tables-types > li:nth-child(3)'
);

let developer_list = document.querySelector('#developers');
let coordinator_list = document.querySelector('#coordinators');
let all_list = document.querySelector('#all');

console.log(all_button);
console.log(all_list);


developer_button.addEventListener('click', event => {
  event.preventDefault();

  if (developer_list.classList.contains('d-none')) {
    all_list.classList.add('d-none');
    all_button.classList.remove('active');
    developer_list.classList.remove('d-none');
    coordinator_list.classList.add('d-none');
    developer_button.classList.add('active');
    coordinator_button.classList.remove('active');
  }
});

coordinator_button.addEventListener('click', event => {
  event.preventDefault();
  if (coordinator_list.classList.contains('d-none')) {
    all_list.classList.add('d-none');
    all_button.classList.remove('active');
    coordinator_list.classList.remove('d-none');
    developer_list.classList.add('d-none');
    developer_button.classList.remove('active');
    coordinator_button.classList.add('active');
  }
});

all_button.addEventListener('click', event => {
  event.preventDefault();
  if (all_list.classList.contains('d-none')) {
    all_list.classList.remove('d-none');
    all_button.classList.add('active');
    coordinator_list.classList.add('d-none');
    developer_list.classList.add('d-none');
    developer_button.classList.remove('active');
    coordinator_button.classList.remove('active');
  }
});

const user_infos = document.querySelectorAll('.info');
console.log(user_infos);

user_infos.forEach(elem =>
  elem.addEventListener('mouseover', event => {
    console.log('oioi');
    event.preventDefault();
    let promote = elem.querySelector('.promote button');
    promote.classList.remove('d-none');
  })
);

user_infos.forEach(elem =>
  elem.addEventListener('mouseleave', event => {
    event.preventDefault();
    let promote = elem.querySelector('.promote button');
    promote.classList.add('d-none');
  })
);
