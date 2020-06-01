const read_more_btns = document.getElementsByClassName('read-more');

[...read_more_btns].forEach(btn => btn.addEventListener('click', ()=> {

    const content = document.getElementById(btn.getAttribute('data-target'));
    const [small_txt, full_txt] =  [...content.querySelectorAll('p')];
    small_txt.classList.toggle('d-none');
    full_txt.classList.toggle('d-none');
   
    if (btn.textContent === 'Read more') {
        btn.textContent = 'Read less';
    } else {
        btn.textContent = 'Read less';
    }

}));