
/* fecth from the database */
let messages = [
    { type: 'invitation', sender: 'John', date: '1269558180', team: "xoxo" },
    { type: 'kicked', sender: 'Tiago', date: '1269558180', team: "wow" },
    { type: 'task', date: '1269558180', team: "xoxo" },
    { type: 'meeting', date: '1269558180', team: "lolo" } // system messages and reports to the admin
];

function renderMessages() {
    messages.forEach(message => {
        let msg;
        switch (message.type) {
            case 'invitation':
                msg = new invitation(message.type, message.sender, message.date, message.team);
                break;
            case 'kicked':
                msg = new kicked(message.type, message.sender, message.date, message.team);
                break;
            case 'task':
                msg = new task(message.type, message.date, message.team);
                break;
            case 'meeting':
                msg = new meeting(message.type, message.date, message.team);
                break;
            default: return;

        }

        msg.render();

    })
}


class message {

    constructor(type, date) {
        this.type = type;
        this.date = this.timestampToDate(date);
        this.notification_list = document.querySelector('.notification-container');

    }

    render() {
        throw new Error('You have to implement the method render!');
    }

    timestampToDate(dateArg) {
        let date = new Date(dateArg * 1000);
        let hours = date.getHours();
        let minutes = "0" + date.getMinutes();
        let seconds = "0" + date.getSeconds();

        let formattedTime = hours + ':' + minutes.substr(-2) + ':' + seconds.substr(-2);
        return formattedTime;
    }

    /*to add generic classes */
    addClassesToElementList(contentTemplate) {
        contentTemplate.classList.add("m-2", "p-2", "notification-list-item");
    }
}


class invitation extends message {
    constructor(type, sender, date, team) {
        super(type, date);
        this.sender = sender;
        this.team = team;
    }

    render() {
        let contentTemplate = document.createElement('li');
        this.addClassesToElementList(contentTemplate);

        let upperContent = document.createElement('div')
        upperContent.classList.add('d-flex', 'justify-content-between');
        upperContent.innerHTML +=
            `<div class = "d-flex align-items-center">
                <img class = "m-2" src="./assets/profile.png" alt="profile_pic" style="width: 40px">
                <p>${this.sender} invited you to the team ${this.team}</p>
            </div>
            <p class = "m-2">${this.date}</p>`;

        contentTemplate.appendChild(upperContent)

        contentTemplate.innerHTML += `<button type="submit" class="btn btn-primary mx-2">Accept <i class="fas fa-check"></i></button>`
        contentTemplate.innerHTML += `<button type="submit" class="btn btn-primary mx-2">Deny <i class="fas fa-times"></i></button>`
        this.notification_list.appendChild(contentTemplate);

    }
}

class kicked extends message {

    constructor(type, sender, date, team) {
        super(type, date);
        this.sender = sender;
        this.team = team;
    }

    render() {

        let contentTemplate = document.createElement('li');
        this.addClassesToElementList(contentTemplate);

        let upperContent = document.createElement('div')
        upperContent.classList.add('d-flex', 'justify-content-between');
        upperContent.innerHTML +=
            `<div class = "d-flex align-items-center justify-content-center">
                <img class = "m-2" src="./assets/profile.png" alt="profile_pic" style="width: 40px">
                <p>${this.sender} kicked out of the team ${this.team}
            </div>
            <p class = "m-2">${this.date}</p>`;

        contentTemplate.appendChild(upperContent)

        this.addClassesToElementList(contentTemplate);
        this.notification_list.appendChild(contentTemplate);
    }
}


class task extends message {
    constructor(type, date, team) {
        super(type, date);
        this.team = team;
    }

    render() {

        let contentTemplate = document.createElement('li');
        let upperContent = document.createElement('div')
        upperContent.classList.add('d-flex', 'justify-content-between');
        upperContent.innerHTML += `<p><i class="fas fa-tasks"></i> You have a task to finish for the team ${this.team} until ${this.date}</p>
                                <p>${this.date}</p>`;

        contentTemplate.appendChild(upperContent)
        this.addClassesToElementList(contentTemplate);
        this.notification_list.appendChild(contentTemplate);

    }
}

class meeting extends message {
    constructor(type, date, team) {
        super(type, date);
        this.team = team;
    }

    render() {
        let contentTemplate = document.createElement('li');
        let upperContent = document.createElement('div')
        upperContent.classList.add('d-flex', 'justify-content-between');
        upperContent.innerHTML += `<p><i class="fas fa-calendar-alt"></i> You have a meeting for ${this.team} at ${this.date}</p>
                                <p>${this.date}</p>`;

        contentTemplate.appendChild(upperContent)
        this.addClassesToElementList(contentTemplate);
        this.notification_list.appendChild(contentTemplate);
    }
}

/*calls */
renderMessages();



