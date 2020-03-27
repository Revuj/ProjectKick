const developer_button = document.querySelector(
  '#tables-types > li:nth-child(1)'
);
const coordinator_button = document.querySelector(
  '#tables-types > li:nth-child(2)'
);

developer_button.addEventListener('click', event => {
  event.preventDefault();

  const developer_list = document.querySelector('#developers');
  if (developer_list.classList.contains('d-none')) {
    const coordinator_list = document.querySelector('#coordinators');

    developer_list.classList.remove('d-none');
    coordinator_list.classList.add('d-none');
    developer_button.classList.add('active');
    coordinator_button.classList.remove('active');
  }
});

coordinator_button.addEventListener('click', event => {
  event.preventDefault();
  const coordinator_list = document.querySelector('#coordinators');
  if (coordinator_list.classList.contains('d-none')) {
    const developer_list = document.querySelector('#developers');

    coordinator_list.classList.remove('d-none');
    developer_list.classList.add('d-none');

    developer_button.classList.remove('active');
    coordinator_button.classList.add('active');
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
