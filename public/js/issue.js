const comment = document.getElementById('new-comment');
const upvotes = document.querySelectorAll('.upvote');
const downvotes = document.querySelectorAll('.downvote');


upvotes.forEach(upvoteArrow => upvoteArrow.addEventListener('click', upvote.bind(upvoteArrow)));
downvotes.forEach(downvoteArrow => downvoteArrow.addEventListener('click', downvote.bind(downvoteArrow)));

function upvote() {
  const comment_id = this.parentNode.getAttribute('data-target');
  const upvote = 1  ;
  vote(comment_id, upvote);
}

function downvote() {
  const comment_id = this.parentNode.getAttribute('data-target');
  const upvote = -1;
  vote(comment_id, upvote);
}

const nth = function(d) {
  if (d > 3 && d < 21) return 'th';
  switch (d % 10) {
    case 1:  return "st";
    case 2:  return "nd";
    case 3:  return "rd";
    default: return "th";
  }
}

function createComment(comment, current_user) {

  const date = new Date(comment['creation_date']);
  let h = date.getHours(), m = date.getMinutes();
  let _time = (h > 12) ? (h-12 + ':' + m +'pm') : (h + ':' + m +'am');

  let day_week = {
    0 :'Sunday',
    1 :'Monday',
    2 :'Tuesday',
    3 :'Wednesday',
    4 :'Thursday',
    5 :'Friday',
    6 :'Sathurday'
  }

  let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];


  const time = _time + ' on ' +  day_week[date.getDay()] + " " + date.getDate() + nth(date.getDate()) + " " + months[date.getMonth()] + " " + date.getFullYear();

  let new_comment = document.createElement('div');
  new_comment.classList.add('comment', 'd-flex', 'border-bottom', 'mt-4', 'pb-1');

    new_comment.innerHTML  = `
    <img class="comment-author" src="/assets/avatars/${current_user['photo_path']}.png" alt="${current_user['username']} profile picture">

    <div class="comment-detail ml-3">
      <h6>
        <a href="/users/${current_user['id']}"><span class="author-reference">${current_user['username']}</span></a>
        <span class="comment-timestamp ml-1"> ${time}</span>
      </h6>
      <p>
        ${comment['content']}
      </p>
  </div>`;

  let voting = document.createElement('div');
  voting.classList.add('karma', 'ml-auto', 'mr-3', 'd-flex', 'flex-column');
  voting.setAttribute('data-target', `${comment['id']}` );

  let child1 = document.createElement('i');
  child1.classList.add('fas', 'fa-chevron-up', 'upvote');
  child1.setAttribute('aria-hidden', true);

  let child2 = document.createElement('p');
  child2.classList.add('mb-0', 'text-center');
  child2.textContent = 0;

  let child3 = document.createElement('i');
  child3.classList.add('fas', 'fa-chevron-down', 'downvote');
  child1.setAttribute('aria-hidden', true);

  voting.appendChild(child1);
  voting.appendChild(child2);
  voting.appendChild(child3);

  new_comment.appendChild(voting);

  document.querySelector('.comments-container').prepend(new_comment);
}

async function makeComment() {
  const user_id = comment.getAttribute('data-user');
  const issue_id = comment.getAttribute('data-issue');
  const content = comment.value;

  let init = {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
    body: encodeForAjax({ user_id, issue_id, content })
  }

  fetch(`/api/issues/comment`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then(data => {
          if ('errors' in data) {
            const error_message = data['errors']['content'][0];
            const div_elem = document.getElementById('error-write');
            div_elem.querySelector('.content').textContent = error_message;
            div_elem.classList.remove('d-none');
            setTimeout(() => {
              div_elem.classList.add('d-none');
              div_elem.querySelector('.content').textContent = "";
            }, 3500);
          }
          else {
            const comment = data[0];
            const current_user = data[1];
            createComment(comment, current_user)


          }
        })
      }
      else {

        console.log('Network response was not ok.' + JSON.stringify(data));
      }
    }).catch(function (error) {
      console.log('There has been a problem with your fetch operation: ' + error.message);
    });

}

async function vote(comment_id, upvote) {

  let init = {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
    body: encodeForAjax({ comment_id, upvote})
  }

  fetch(`/api/votes`, init)
  .then(function (response) {
    if (response.ok) {
      response.json().then(data => {
        if ('errors' in data) {
          /*
          const error_message = data['errors']['content'][0];
          const div_elem = document.getElementById('error-write');
          div_elem.querySelector('.content').textContent = error_message;
          div_elem.classList.remove('d-none');
          setTimeout(() => {
            div_elem.classList.add('d-none');
            div_elem.querySelector('.content').textContent = "";
          }, 3500);*/
          console.log(data)
        }
        else {
          /*
          const comment = data[0];
          const current_user = data[1];
          createComment(comment, current_user)*/
          console.log(data)
        }
      })
    }
    else {

      console.log('Network response was not ok.' + JSON.stringify(data));
    }
  }).catch(function (error) {
    console.log('There has been a problem with your fetch operation: ' + error.message);
  });

}


comment.addEventListener('keypress', function (event) {
  if (event.keyCode === 13) {
    event.preventDefault();
    makeComment();
    comment.value = "";
  }
});