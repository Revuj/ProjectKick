let notifications_filters = document.querySelectorAll(
  "#notifications-list-container li"
);

const others = document.getElementById('others-notifications');
const all = document.getElementById('all-notifications');


/* fecth from the database */
let messages = [
  { type: "invited", sender: "John", date: "just now", project: "lbaw2025" },
  { type: "invited", sender: "Abelha", date: "2 days ago", project: "sdis" },
  {
    type: "invited",
    sender: "Abelha",
    date: "1 month ago",
    project: "iart-proj"
  },
  { type: "kicked", sender: "Tiago", date: "3 days ago", project: "ltw" },
  {
    type: "assigned",
    date: "1 minute ago",
    project: "BDAD",
    title: "Delivery 1st Project"
  },
  {
    type: "assigned",
    date: "1 day ago",
    project: "BDAD",
    title: "Normalize database"
  },
  { type: "assigned", date: "2 weeks ago", project: "PPIN", title: "Namaste" },
  {
    type: "issue",
    date: "1 minute ago",
    project: "LPOO",
    title: "Mutation Tests"
  },
  { type: "meeting", date: "1 week ago", project: "LPOO" } // system messages and reports to the admin
];

notifications_filters.forEach(elem =>
  elem.addEventListener("click", event => {
    notifications_filters.forEach(elem => elem.classList.remove("active"));
    elem.classList.add("active");
    let notifications_container = document.querySelector(
      ".notification-container"
    );
    notifications_container.innerHTML = "";
    let filtered_messages;
    switch (elem.id) {
      case "assigned-notifications":
        filtered_messages = messages.filter(
          message => message.type == "assigned"
        );
        break;
      case "invited-notifications":
        filtered_messages = messages.filter(
          message => message.type == "invited"
        );
        break;
      case "meetings-notifications":
        filtered_messages = messages.filter(
          message => message.type == "meeting"
        );
        break;
      case "others-notifications":
        filtered_messages = messages.filter(
          message => message.type == "kicked" || message.type == "issue"
        );
        break;
      case "all-notifications":
        filtered_messages = messages;
        break;
    }
    renderMessages(filtered_messages);
  })
);

function renderMessages(messages) {
  messages.forEach(message => {
    let msg;
    switch (message.type) {
      case "invited":
        msg = new invited(
          message.type,
          message.sender,
          message.date,
          message.project
        );
        break;
      case "kicked":
        msg = new kicked(
          message.type,
          message.sender,
          message.date,
          message.project
        );
        break;
      case "assigned":
        msg = new assigned(
          message.type,
          message.date,
          message.project,
          message.title
        );
        break;
      case "issue":
        msg = new issue(
          message.type,
          message.date,
          message.project,
          message.title
        );
        break;
      case "meeting":
        msg = new meeting(message.type, message.date, message.project);
        break;
      default:
        return;
    }

    msg.render();
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

class invited extends message {
  constructor(type, sender, date, project) {
    super(type, date);
    this.sender = sender;
    this.project = project;
  }

  render() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add("invited-notification");
    this.addClassesToElementList(contentTemplate);

    let upperContent = document.createElement("div");
    upperContent.classList.add("d-flex", "justify-content-between");
    upperContent.innerHTML += `<div class = "d-flex align-items-center">
                <img class = "m-2" src="./assets/profile.png" alt="profile_pic" style="width: 40px">
                <p><span class="author-reference">${this.sender} </span>invited you to the project <span class="project-reference">${this.project}</span></p>
            </div>
            <p class="timestamp smaller-text m-2">${this.date}</p>`;

    contentTemplate.appendChild(upperContent);

    contentTemplate.innerHTML += `<button type="submit" class="custom-button primary-button mx-2">Accept <i class="fas fa-check"></i></button>`;
    contentTemplate.innerHTML += `<button type="submit" class="custom-button secondary-button mx-2">Deny <i class="fas fa-times"></i></button>`;
    this.notification_list.appendChild(contentTemplate);
  }
}

class kicked extends message {
  constructor(type, sender, date, project) {
    super(type, date);
    this.sender = sender;
    this.project = project;
  }

  render() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add("kicked-notification");
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

  getNewElement() {
    let contentTemplate = document.createElement("li");
    contentTemplate.classList.add("kicked-notification");

    contentTemplate.innerHTML = `
    <li class = "kicked-notification">
      <div class = "d-flex justify-content-between">
        <div class = "d-flex align-items-center justify-content-center">
          <img class = "m-2" src="./assets/profile.png" alt="profile_pic" style="width: 40px">
          <p><span class="author-reference">${this.sender} </span>kicked you out of the project <span class="project-reference">${this.project}</span>
        </div>
        <p class="timestamp smaller-text m-2">${this.date}</p>
      </div>
    </li>
    `;
    return contentTemplate;
  }
}

class assigned extends message {
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

