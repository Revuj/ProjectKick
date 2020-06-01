console.log("lets go")

const fitlers = document.querySelectorAll('#tables-types > li');


[...fitlers].forEach(elem => elem.addEventListener('click', () => {
    let active_content = document.querySelector('#history .active');
    active_content.classList.remove('active');
    active_content.classList.add('d-none');
    console.log(active_content);

    let next_content = document.getElementById(elem.getAttribute('data-target'));
    next_content.classList.add('active');
    next_content.classList.remove('d-none');
    console.log(next_content)
    
    let active_filter =  document.querySelector('#tables-types .active');
    active_filter.classList.remove('active');
    elem.classList.add('active');

    
}));