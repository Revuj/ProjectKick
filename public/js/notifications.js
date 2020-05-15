let notifications_filters = document.querySelectorAll(
  "#notifications-list-container li"
);

let notifications_containers = document.querySelectorAll(
  ".notification-container"
);

let accept_buttons = document.querySelectorAll(
  '.custom-button.primary-button'
);

let refuse_buttons = document.querySelectorAll(
  '.custom-button.secondary-button'
);

refuse_buttons.forEach(btn => btn.addEventListener('click', deleteInvite.bind(btn)));
accept_buttons.forEach(btn => btn.addEventListener('click', acceptInvite.bind(btn)));

let all = document.getElementById('all-notifications');
let assigned = document.getElementById('assigned-notifications');
let invited = document.getElementById('invited-notifications');
let kicked = document.getElementById('kicked-notifications');
let meetings = document.getElementById('meetings-notifications');

/*notification containers:*/
let all_container = document.getElementById('all');
let invited_container = document.getElementById('invited');
let kicked_container = document.getElementById('kicked');
let meeting_container = document.getElementById('meetings');
let assigned_container = document.getElementById('assigned');

let all_counter = all.querySelector('.type-counter');
let invited_counter = invited.querySelector('.type-counter');
let kicked_counter = kicked.querySelector('.type-counter');

notifications_filters.forEach(elem => elem.addEventListener('click', (e) => {
  let active_notif = document.querySelector('#notifications-list-container li.active');
  if (active_notif === elem) {
    return;
  }
  active_notif.classList.remove('active');
  elem.classList.add('active');


  let active_container = document.querySelector('.notification-container.active');
  let target_container = document.getElementById(elem.id.split('-')[0]);
  console.log(target_container)
  active_container.classList.remove('active');
  active_container.classList.add('d-none');

  target_container.classList.add('active');
  target_container.classList.remove('d-none');
}));



async function deleteInvite() {
  let element = this;
  let invite_id = element.getAttribute('data-invite');

  let init = {
    method: 'DELETE',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }

  fetch(`/api/notification/${invite_id}/invite`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then(data => {
          if (message in data) {
            alert(response['message']);
          }
          else {
            let btns = document.querySelectorAll(`.secondary-button[data-invite = '${invite_id}']`);
            console.log(data)
            btns.forEach((btn) => {
              console.log(btn.parentNode);
              btn.parentNode.remove();

            });
            all_counter.textContent = parseInt(all_counter.textContent) - 1;
            invited_counter.textContent = parseInt(invited_counter.textContent) - 1;
          }
        })
      }
      else {
        console.log('Network response was not ok.');
      }
    }).catch(function (error) {
      console.log('There has been a problem with your fetch operation: ' + error.message);
    });

}

async function acceptInvite() {
  let element = this;
  let project_id = element.getAttribute('data-invite');

  let init = {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }
  fetch(`/api/project/${project_id}/invite`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then(data => {
          if (message in data) {
            alert(response['message']);
          }
          else {
            console.log(data);
            // perform delete
          }
        })
      }
      else {
        console.log('Network response was not ok.');
      }
    }).catch(function (error) {
      console.log('There has been a problem with your fetch operation: ' + error.message);
    });

}



class message {
  constructor(type, date) {
    this.type = type;
    //this.date = this.timestampToDate(date);
    this.date = date;
    this.notification_list = document.querySelector(".notification-container");
  }

  render() {
    throw new Error("You have to implement the method render!");
  }

  timestampToDate(dateArg) {
    let date = new Date(dateArg * 1000);
    let hours = date.getHours();
    let minutes = "0" + date.getMinutes();
    let seconds = "0" + date.getSeconds();

    let formattedTime =
      hours + ":" + minutes.substr(-2) + ":" + seconds.substr(-2);
    return formattedTime;
  }

  /*to add generic classes */
  addClassesToElementList(contentTemplate) {
    contentTemplate.classList.add(
      "m-2",
      "p-2",
      "notification-list-item",
      "border-bottom"
    );
  }
}


class invite extends message {
  constructor(type, sender, date, project) {
    super(type, date);
    this.sender = sender;
    this.project = project;
  }

  //{TODO PHOTO PATH CHECK}
  getElement() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add("invited-notification");
    this.addClassesToElementList(contentTemplate);

    let upperContent = document.createElement("div");
    upperContent.classList.add("d-flex", "justify-content-between");
    upperContent.innerHTML += `<div class ="d-flex align-items-center">
                <img class = "m-2" src="/assets/profile.png"
                alt="profile_pic" style="width: 40px"/>
                <p><span class="author-reference">${this.sender} </span>invited you to the project <span class="project-reference">${this.project}</span></p>
                </div>
                <p class="timestamp smaller-text m-2"> ${mappingDifDateDescript(this.date)}</p>`;

    contentTemplate.appendChild(upperContent);


    let delete_btn = document.createElement("button");
    delete_btn.classList.add("custom-button", "primary-button", "mx-2");
    delete_btn.innerHTML = 'Accept <i class="fas fa-check"></i>';
    delete_btn.addEventListener('click', () => alert("go"));

    let accept_btn = document.createElement("button");
    accept_btn.classList.add("custom-button", "secondary-button", "mx-2");
    accept_btn.innerHTML = 'Deny <i class="fas fa-times"></i>';
    accept_btn.addEventListener('click', () => alert("go"));

    contentTemplate.appendChild(delete_btn);
    contentTemplate.appendChild(accept_btn);

    return contentTemplate;
  }

}

class kick extends message {
  constructor(type, sender, date, project) {
    super(type, date);
    this.sender = sender;
    this.project = project;
  }

  render() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add("kicked-notification", "m-2", "p-2", "notification-list-item", "border-bottom");
    this.addClassesToElementList(contentTemplate);

    let upperContent = document.createElement("div");
    upperContent.classList.add("d-flex", "justify-content-between");
    upperContent.innerHTML += `<div class = "d-flex align-items-center justify-content-center">
                <img class = "m-2" src="./assets/profile.png" alt="profile_pic" style="width: 40px">
                <p><span class="author-reference">${this.sender} </span>kicked you out of the project <span class="project-reference">${this.project}</span>
            </div>
            <p class="timestamp smaller-text m-2">${this.date}</p>`;

    contentTemplate.appendChild(upperContent);

    this.addClassesToElementList(contentTemplate);
    this.notification_list.appendChild(contentTemplate);
  }

  getElement() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add("kicked-notification", "m-2", "p-2", "notification-list-item", "border-bottom");

    contentTemplate.innerHTML = `
      <div class = "d-flex justify-content-between">
        <div class = "d-flex align-items-center justify-content-center">
        <img class = "m-2" src="/assets/profile.png"
        alt="profile_pic" style="width: 40px"/>
        <p><span class="author-reference">${this.sender} </span>kicked you out of the project <span class="project-reference">${this.project}</span></p>
        </div>
        <p class="timestamp smaller-text m-2">${this.date}</p>
      </div>
    `;
    return contentTemplate;
  }
}

class assign extends message {
  constructor(type, date, project, title) {
    super(type, date);
    this.project = project;
    this.title = title;
  }

  render() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add("assigned-notification");
    let upperContent = document.createElement("div");
    upperContent.classList.add("d-flex", "justify-content-between");
    upperContent.innerHTML += `<p> The issue <span class="issue-reference">${this.title}</span> on the project <span class="project-reference">${this.project}</span> has been assigned to you</p>
                                <p class="timestamp smaller-text">${this.date}</p>`;

    contentTemplate.appendChild(upperContent);
    contentTemplate.innerHTML += `<a href="issue.html"><button type="submit" class="custom-button primary-button mx-2">Go to Issue</button></a>`;
    this.notification_list.appendChild(contentTemplate);
    this.addClassesToElementList(contentTemplate);
    this.notification_list.appendChild(contentTemplate);
  }
}

class issue extends message {
  constructor(type, date, project, title) {
    super(type, date);
    this.project = project;
    this.title = title;
  }

  render() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add("issue-notification");
    let upperContent = document.createElement("div");
    upperContent.classList.add("d-flex", "justify-content-between");
    upperContent.innerHTML += `<p><i class="fas fa-issues"></i> The issue <span class="issue-reference">${this.title}</span> on the project <span class="project-reference">${this.project}</span> is reaching it's deadline</p>
                                <p class="timestamp smaller-text">${this.date}</p>`;

    contentTemplate.appendChild(upperContent);
    contentTemplate.innerHTML += `<a href="issue.html"><button type="submit" class="custom-button primary-button mx-2">Go to Issue</button></a>`;
    this.notification_list.appendChild(contentTemplate);
    this.addClassesToElementList(contentTemplate);
    this.notification_list.appendChild(contentTemplate);
  }
}

class meeting extends message {
  constructor(type, date, project) {
    super(type, date);
    this.project = project;
  }

  render() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add("meeting-notification");
    let upperContent = document.createElement("div");
    upperContent.classList.add("d-flex", "justify-content-between");
    upperContent.innerHTML += `<p><i class="fas fa-calendar-alt"></i> You have a meeting for <span class="project-reference">${this.project}</span> at ${this.date}</p>
                                <p class="timestamp smaller-text">${this.date}</p>`;

    contentTemplate.appendChild(upperContent);
    contentTemplate.innerHTML += `<a href="calendar.html"><button type="submit" class="custom-button primary-button mx-2">Go to Calendar</button></a>`;

    this.addClassesToElementList(contentTemplate);
    this.notification_list.appendChild(contentTemplate);
  }
}

// ================================================================
// ================ LISTENING TO THE CHANNELS =====================
// ================================================================



invitation_channel.bind('invitation', function (data) {
  let new_invite = new invite('invited', data['sender'],
    data['date'], data['project']).getElement();

  all_counter.textContent = parseInt(all_counter.textContent) + 1;
  invited_counter.textContent = parseInt(invited_counter.textContent) + 1;

  let inviteClone = new_invite.cloneNode(true);
  all_container.prepend(new_invite);
  invited_container.prepend(inviteClone);
});

kicking_channel.bind('kicked-out', function (data) {
  let new_kicked = new kick('invited', data['sender'],
    data['date'], data['project']).getElement();

  all_counter.textContent = parseInt(all_counter.textContent) + 1;
  kicked_counter.textContent = parseInt(invited_counter.textContent) + 1;

  let kickedClone = new_kicked.cloneNode(true);
  all_container.prepend(new_kicked);
  kicked_container.prepend(kickedClone);
});





