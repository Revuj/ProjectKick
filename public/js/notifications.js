let notifications_filters = document.querySelectorAll(
  "#notifications-list-container li"
);

let notifications_containers = document.querySelectorAll(
  ".notification-container"
);

let accept_buttons = document.querySelectorAll(".custom-button.primary-button");

let refuse_buttons = document.querySelectorAll(
  ".custom-button.secondary-button"
);

let seen_buttons = document.querySelectorAll(".custom-button.seen-button");

refuse_buttons.forEach((btn) =>
  btn.addEventListener("click", deleteInvite.bind(btn))
);

accept_buttons.forEach((btn) =>
  btn.addEventListener("click", acceptInvite.bind(btn))
);

seen_buttons.forEach((btn) =>
  btn.addEventListener("click", seenNotification.bind(btn))
);

let all = document.getElementById("all-notifications");
let assigned = document.getElementById("assigned-notifications");
let invited = document.getElementById("invited-notifications");
let kicked = document.getElementById("kicked-notifications");
let meetings = document.getElementById("meetings-notifications");

/*notification containers:*/
let all_container = document.getElementById("all");
let invited_container = document.getElementById("invited");
let kicked_container = document.getElementById("kicked");
let meeting_container = document.getElementById("meetings");
let assigned_container = document.getElementById("assigned");

let all_counter = all.querySelector(".type-counter");
let invited_counter = invited.querySelector(".type-counter");
let kicked_counter = kicked.querySelector(".type-counter");
let meeting_counter = meetings.querySelector(".type-counter");
let assigned_counter = assigned.querySelector(".type-counter");

notifications_filters.forEach((elem) =>
  elem.addEventListener("click", (e) => {
    let active_notif = document.querySelector(
      "#notifications-list-container li.active"
    );
    if (active_notif === elem) {
      return;
    }
    active_notif.classList.remove("active");
    elem.classList.add("active");

    let active_container = document.querySelector(
      ".notification-container.active"
    );
    let target_container = document.getElementById(elem.id.split("-")[0]);
    console.log(target_container);
    active_container.classList.remove("active");
    active_container.classList.add("d-none");

    target_container.classList.add("active");
    target_container.classList.remove("d-none");
  })
);

async function seenNotification() {
  let element = this;
  let notification_id = element.getAttribute("data-notification");
  let type = element.getAttribute("data-notification-type");

  let init = {
    method: "DELETE",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]').content,
    },
  };

  fetch(`/api/notification/${notification_id}/` + type, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then((data) => {
          if (message in data) {
            alert(response["message"]);
          } else {
            let btns = document.querySelectorAll(
              `.seen-button[data-notification = '${notification_id}']`
            );
            console.log(btns);
            btns.forEach((btn) => {
              console.log("oioioioi" + btn.parentNode);
              btn.parentNode.remove();
            });
            all_counter.textContent = parseInt(all_counter.textContent) - 1;
            switch (type) {
              case "kick":
                kicked_counter.textContent =
                  parseInt(kicked_counter.textContent) - 1;
                break;
              case "assign":
                assigned_counter.textContent =
                  parseInt(assigned_counter.textContent) - 1;
                break;
              case "meeting":
                meeting_counter.textContent =
                  parseInt(meeting_counter.textContent) - 1;
                break;
            }
            // invited_counter.textContent =
            //   parseInt(invited_counter.textContent) - 1;
          }
        });
      } else {
        console.log("Network response was not ok.");
      }
    })
    .catch(function (error) {
      console.log(
        "There has been a problem with your fetch operation: " + error.message
      );
    });
}

async function deleteInvite() {
  let element = this;
  let invite_id = element.getAttribute("data-notification");

  let init = {
    method: "delete",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]').content,
    },
  };

  console.log({ invite_id });
  fetch(`/api/notification/${invite_id}/invite`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then((data) => {
          if (message in data) {
            alert(response["message"]);
          } else {
            let btns = document.querySelectorAll(
              `.secondary-button[data-notification = '${invite_id}']`
            );
            console.log(data);
            btns.forEach((btn) => {
              console.log(btn.parentNode);
              btn.parentNode.remove();
            });
            all_counter.textContent = parseInt(all_counter.textContent) - 1;
            invited_counter.textContent =
              parseInt(invited_counter.textContent) - 1;
          }
        });
      } else {
        console.log("Network response was not ok.");
      }
    })
    .catch(function (error) {
      console.log(
        "There has been a problem with your fetch operation: " + error.message
      );
    });
}

async function acceptInvite() {
  let element = this;
  let project_id = element.getAttribute("data-invite");

  let init = {
    method: "PUT",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]').content,
    },
  };
  fetch(`/api/project/${project_id}/invite`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then((data) => {
          if (message in data) {
            alert(response["message"]);
          } else {
            console.log(data);
          }
        });
      } else {
        console.log("Network response was not ok.");
      }
    })
    .catch(function (error) {
      console.log(
        "There has been a problem with your fetch operation: " + error.message
      );
    });

  let delete_btn = element.nextElementSibling;
  console.log(delete_btn);
  deleteInvite.call(delete_btn);
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
  constructor(type, sender, date, project, projectId, notification, photo) {
    super(type, date);
    this.sender = sender;
    this.project = project;
    this.projectId = projectId;
    this.notification = notification;
    this.photo = photo;
  }

  //{TODO PHOTO PATH CHECK}
  getElement() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add("invited-notification");
    this.addClassesToElementList(contentTemplate);

    let upperContent = document.createElement("div");
    upperContent.classList.add("d-flex", "justify-content-between");
    upperContent.innerHTML += `<div class ="d-flex align-items-center">
    <img  class="m-2" src="/assets/avatars/${this.photo}.png" alt="${
      this.sender
    } profile picture" style = "width:40px" />
                <p><span class="author-reference">${
                  this.sender
                } </span>invited you to the project <span class="project-reference">${
      this.project
    }</span></p>
                </div>
                <p class="timestamp smaller-text m-2"> ${mappingDifDateDescript(
                  this.date
                )}</p>`;

    contentTemplate.appendChild(upperContent);

    let accept_btn = document.createElement("button");
    accept_btn.classList.add("custom-button", "primary-button", "mx-2");
    accept_btn.dataset.invite = this.projectId;
    accept_btn.innerHTML = 'Accept <i class="fas fa-check"></i>';
    accept_btn.addEventListener("click", acceptInvite.bind(accept_btn));

    let delete_btn = document.createElement("button");
    delete_btn.classList.add("custom-button", "secondary-button", "mx-2");
    delete_btn.dataset.notification = this.notification;
    delete_btn.innerHTML = 'Deny <i class="fas fa-times"></i>';
    delete_btn.addEventListener("click", deleteInvite.bind(delete_btn));

    contentTemplate.appendChild(accept_btn);
    contentTemplate.appendChild(delete_btn);

    return contentTemplate;
  }
}

class kick extends message {
  constructor(type, sender, date, project, notification, photo) {
    super(type, date);
    this.sender = sender;
    this.project = project;
    this.notification = notification;
    this.photo = photo;
  }

  render() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add(
      "kicked-notification",
      "m-2",
      "p-2",
      "notification-list-item",
      "border-bottom"
    );
    this.addClassesToElementList(contentTemplate);

    let upperContent = document.createElement("div");
    upperContent.classList.add("d-flex", "justify-content-between");
    upperContent.innerHTML += `<div class = "d-flex align-items-center justify-content-center">
                <img class = "m-2" src="./assets/profile.png" alt="profile_pic" style="width: 40px">
                <p><span class="author-reference">${this.sender} </span>kicked you out of the project <span class="project-reference">${this.project}</span>
            </div>
            <p class="timestamp smaller-text m-2">${this.date}</p>`;

    contentTemplate.appendChild(upperContent);

    contentTemplate.innerHTML += `
      <button data-notification-type="meeting" data-notification="88" type="button" 
      class="custom-button seen-button mx-2">Seen <i class="fas fa-check" aria-hidden="true"></i></button>
    `;

    this.addClassesToElementList(contentTemplate);
    this.notification_list.appendChild(contentTemplate);
  }

  getElement() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add(
      "kicked-notification",
      "m-2",
      "p-2",
      "notification-list-item",
      "border-bottom"
    );

    contentTemplate.innerHTML = `
      <div class = "d-flex justify-content-between">
        <div class = "d-flex align-items-center justify-content-center">
        <img  class="m-2" src="/assets/avatars/${this.photo}.png" alt="${
      this.sender
    } profile picture" style = "width:40px" />
        <p><span class="author-reference">${
          this.sender
        } </span>kicked you out of the project <span class="project-reference">${
      this.project
    }</span></p>
        </div>
        <p class="timestamp smaller-text m-2">${mappingDifDateDescript(
          this.date
        )}</p>
      </div>
    `;

    let seen_btn = document.createElement("button");
    seen_btn.classList.add(
      "seen-button",
      "custom-button",
      "primary-button",
      "mx-2"
    );
    seen_btn.dataset.notification = this.notification;
    seen_btn.setAttribute("data-notification-type", this.type);
    seen_btn.innerHTML = 'Seen <i class="fas fa-check"></i>';
    seen_btn.addEventListener("click", seenNotification.bind(seen_btn));
    contentTemplate.appendChild(seen_btn);

    return contentTemplate;
  }
}

class assign extends message {
  constructor(type, sender, date, issue, issueId, notification, photo) {
    super(type, date);
    this.sender = sender;
    this.issue = issue;
    this.issueId = issueId;
    this.notification = notification;
    this.photo = photo;
  }

  getElement() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add("invited-notification");
    this.addClassesToElementList(contentTemplate);

    let upperContent = document.createElement("div");
    upperContent.classList.add("d-flex", "justify-content-between");
    upperContent.innerHTML += `<div class ="d-flex align-items-center">
    <img  class="m-2" src="/assets/avatars/${this.photo}.png" alt="${
      this.sender
    } profile picture" style = "width:40px" />
                <p><span class="author-reference">${
                  this.sender
                } </span>assigned you to the issue <span class="project-reference">${
      this.issue
    }</span></p>
                </div>
                <p class="timestamp smaller-text m-2"> ${mappingDifDateDescript(
                  this.date
                )}</p>`;

    contentTemplate.appendChild(upperContent);

    let seen_btn = document.createElement("button");
    seen_btn.classList.add(
      "seen-button",
      "custom-button",
      "primary-button",
      "mx-2"
    );
    seen_btn.dataset.notification = this.notification;
    seen_btn.setAttribute("data-notification-type", this.type);
    seen_btn.innerHTML = 'Seen <i class="fas fa-check"></i>';
    seen_btn.addEventListener("click", seenNotification.bind(seen_btn));
    contentTemplate.appendChild(seen_btn);

    return contentTemplate;
  }
}

class issue extends message {
  constructor(type, date, project, title, notification) {
    super(type, date);
    this.project = project;
    this.title = title;
    this.notification = notification;
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
  constructor(
    type,
    project,
    sender,
    receiver,
    date,
    photo,
    project_id,
    notification
  ) {
    super(type, date);
    this.project = project;
    this.sender = sender;
    this.receiver = receiver;
    this.photo = photo;
    this.project_id = project_id;
    this.notification = notification;
  }

  render() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add("meeting-notification");
    let upperContent = document.createElement("div");
    upperContent.classList.add("d-flex", "justify-content-between");
    upperContent.innerHTML += `<p><i class="fas fa-calendar-alt"></i> You have a meeting for <span class="project-reference">${this.project}</span> at ${this.date}</p>
                                <p class="timestamp smaller-text">${this.date}</p>`;

    this.addClassesToElementList(contentTemplate);
    this.notification_list.appendChild(contentTemplate);
  }

  getElement() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add("invited-notification");
    this.addClassesToElementList(contentTemplate);

    let upperContent = document.createElement("div");
    upperContent.classList.add("d-flex", "justify-content-between");
    upperContent.innerHTML += `
    <div class = "d-flex align-items-center justify-content-center">
        <img  class="m-2" src="/assets/avatars/${this.photo}.png" alt="${
      this.sender
    } profile picture" style = "width:40px" />
        <p><span class="author-reference">${
          this.sender
        } </span> set up a meeting for the project <a href="/projects/${
      this.project_id
    }" class="project-reference nostyle clickable">${this.project}</a>
    </div>
    <p class="timestamp smaller-text m-2">${mappingDifDateDescript(
      this.date
    )}</p>
    `;

    contentTemplate.appendChild(upperContent);

    let seen_btn = document.createElement("button");
    seen_btn.classList.add(
      "seen-button",
      "custom-button",
      "primary-button",
      "mx-2"
    );
    seen_btn.dataset.notification = this.notification;
    seen_btn.setAttribute("data-notification-type", this.type);
    seen_btn.innerHTML = 'Seen <i class="fas fa-check"></i>';
    seen_btn.addEventListener("click", seenNotification.bind(seen_btn));
    contentTemplate.appendChild(seen_btn);

    return contentTemplate;
  }
}

// ================================================================
// ================ LISTENING TO THE CHANNELS =====================
// ================================================================

invitation_channel.bind("invitation", function (data) {
  let new_invite = new invite(
    "invited",
    data["sender"],
    data["date"],
    data["project"],
    data["projectId"],
    data["notification_id"],
    data["photo"]
  ).getElement();

  all_counter.textContent = parseInt(all_counter.textContent) + 1;
  invited_counter.textContent = parseInt(invited_counter.textContent) + 1;

  let inviteClone = new_invite.cloneNode(true);
  all_container.prepend(new_invite);
  invited_container.prepend(inviteClone);
});

kicking_channel.bind("kicked-out", function (data) {
  console.log(data);
  let new_kicked = new kick(
    "kick",
    data["sender"],
    data["date"],
    data["project"],
    data["notification"],
    data["photo"]
  ).getElement();

  all_counter.textContent = parseInt(all_counter.textContent) + 1;
  kicked_counter.textContent = parseInt(invited_counter.textContent) + 1;

  let kickedClone = new_kicked.cloneNode(true);
  all_container.prepend(new_kicked);
  kicked_container.prepend(kickedClone);
});

assign_channel.bind("assignment", function (data) {
  console.log(data["sender"], data["date"], data["issue"], data["issueId"]);

  let new_assignment = new assign(
    "assign",
    data["sender"],
    data["date"],
    data["issue"],
    data["issueId"],
    data["notification"],
    data["photo"]
  ).getElement();

  all_counter.textContent = parseInt(all_counter.textContent) + 1;
  assigned_counter.textContent = parseInt(assigned_counter.textContent) + 1;

  let assignmentClone = new_assignment.cloneNode(true);
  all_container.prepend(new_assignment);
  assigned_container.prepend(assignmentClone);
});

meeting_channel.bind("meeting", function (data) {
  let new_meeting = new meeting(
    "meeting",
    data["project"],
    data["sender"],
    data["receiver"],
    data["date"],
    data["senderPhotoPath"],
    data["projectId"],
    data["notification"]
  ).getElement();

  all_counter.textContent = parseInt(all_counter.textContent) + 1;
  meeting_counter.textContent = parseInt(meeting_counter.textContent) + 1;

  let meeting_clone = new_meeting.cloneNode(true);
  all_container.prepend(new_meeting);
  meeting_container.prepend(meeting_clone);
});
