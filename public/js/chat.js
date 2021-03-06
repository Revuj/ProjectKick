const ENTER_KEY_CODE = 13;
let available_chats = document.querySelectorAll(".chat_list");
const sendButton = document.querySelector(".msg_send_btn");
const message = document.querySelector("#messageToSend");
const create_chat_btn = document.querySelector("#create-chat");
let project_id = create_chat_btn.getAttribute("data-project");
let active_chat = document.querySelector(".active_chat");
let msgHistory = document.querySelector(".chat-msgs");

let channel = null;
let toDelete;

var pusher = new Pusher("7d3a9c163bd45174c885", {
  cluster: "eu",
  forceTLS: true,
  auth: {
    headers: {
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
    },
  },
});

function subscribeToChannels() {
  if (active_chat == null) return;
  channel = pusher.subscribe(
    "private-groups." + active_chat.getAttribute("id")
  );
}

function bindAtiveChannel() {
  if (active_chat == null) return;
  channel.bind("my-event", function (data) {
    drawMessageTemplate(data);
    updateScroll();
  });
}

subscribeToChannels();
bindAtiveChannel();

/**
 * Swaps visible chats when one is clicked
 */
function changeChat() {
  let chat = this;
  console.log(this);
  active_chat = document.querySelector(".active_chat");
  if (active_chat == chat) return;

  if (active_chat != null) {
    let new_active_id = chat.getAttribute("id");
    channel.unbind("my-event");
    window.location.href = `/projects/${project_id}/chats/${new_active_id}`;
  }
}

available_chats.forEach((chat) =>
  chat.addEventListener("click", changeChat.bind(chat), false)
);

/**
 *  sends message when click on button
 */
if (sendButton !== null) {
  sendButton.addEventListener("click", (e) => {
    let content = message.value;
    if (content.length === 0) return;
    requestCreateMsg();
    emptyInput(message);
  });
}

/**
 * sends message when pressed enter
 */

if (message !== null) {
  message.addEventListener("keyup", () => {
    if (event.keyCode === ENTER_KEY_CODE) {
      requestCreateMsg();
      emptyInput(message);
    }
  });
}
/**
 * ajax request to create a new message
 */
function requestCreateMsg() {
  const active = document.querySelector(".active_chat").getAttribute("id");
  let url = `/api/chat/${active}/messages`;

  sendAjaxRequest(
    "post",
    url,
    {
      content: message.value,
      channel_id: active,
    },
    messageHandler
  );
}

/**
 * response handler to the new message request
 */
function messageHandler() {
  const response = JSON.parse(this.responseText);
  console.log(response);
}

// missing images
/**
 * template to add message to the page
 * @param {message information} message
 * @param {user information} author
 */
function drawMessageTemplate(message) {
  let active_chat = document.querySelector(".active_chat").getAttribute("id");
  let current_chat = document.querySelector("#chat-msg" + active_chat);

  let image = `
        <img src= "/assets/avatars/${message["photo_path"]}.png" alt="{{$message['username']}} profile picture" />
     `;

  let messageWrapper = document.createElement("div");
  messageWrapper.classList.add("incoming_msg", "d-flex", "align-items-start");
  messageWrapper.innerHTML = `
      <div class="incoming_msg_img">
        ${image}
      </div>
      <div class="message d-flex flex-column align-items-start"> 
            <div class="message-header"><span class="author">${
              message["username"]
            }</span>
            <span class="time_date px-2"> ${getDate(
              message["date"]
            )} </span></div>
            <div class="message-content">
                ${message["message"]}
            </div>
        </div>
    `;
  current_chat.appendChild(messageWrapper);
}

/**
 * button trigger to create a new project
 */
create_chat_btn.addEventListener("click", (e) => {
  let chat_name = document.querySelector("#project-name");
  let chat_description = document.querySelector("#project_description");
  requestNewChat(chat_name.value, chat_description.value);
  emptyInput(chat_name);
  emptyInput(chat_description);
});

/**
 * ajax request to create a new chat
 * @param {name of the project} name
 * @param {description } description
 */
function requestNewChat(name, description) {
  let url = `/api/project/${project_id}/chat`;
  sendAjaxRequest(
    "post",
    url,
    {
      name: name,
      description: description,
    },
    newChatHandler
  );
}

/**
 * response handler to the ajax request to create a new project
 */
function newChatHandler() {
  const response = JSON.parse(this.responseText);
  if ("errors" in response) {
    displayError(response);
  } else {
    addChatTemplate(response[0]);
    console.log(response);
  }
}

/**
 * template to add the new project to the page
 * @param {chat data} chat
 */
function addChatTemplate(chat) {
  let id = chat["id"];
  window.location.replace(`/projects/${project_id}/chats/${id}`);
}

// Delete channel
let deleteButtons = document.getElementsByClassName("delete-channel-button");
[...deleteButtons].forEach((elem) =>
  elem.addEventListener("click", (e) => {
    e.stopPropagation();
    $("#delete-channel-modal").modal("show");
    toDelete = elem.dataset.channel;
  })
);

const deleteButton = document.getElementById("delete-channel-button");
deleteButton.addEventListener("click", deleteChannel);

function deleteHandler() {
  const response = JSON.parse(this.responseText);
  let id = response.id;
  let channel = document.getElementById(id);
  channel.remove();
  if (toDelete === active_chat.getAttribute("id")) {
    window.location.href = `/projects/${project_id}/chats/`;
  }
}

function deleteChannel(e) {
  e.preventDefault();
  sendAjaxRequest("delete", `/api/channels/${toDelete}`, {}, deleteHandler);
}

window.onbeforeunload = confirmExit;

function confirmExit() {
  /*
    for (let key in channels) {
        // check if the property/key is defined in the object itself, not in parent
        if (channels.hasOwnProperty(key)) {
            channels[key].unsubscribe('private-groups.' + key);
        }
    }*/

  channel.unsubscribe("private-groups." + active_chat.getAttribute("id"));
  console.log("unsubscribe");
}

// Scrolling when adding new message
function updateScroll() {
  msgHistory.scrollTop = msgHistory.scrollHeight;
}

//======

function getDate(data) {
  const date = new Date(data.split("+")[0]);
  let h = date.getHours(),
    m = date.getMinutes();
  let _time = h > 12 ? h - 12 + ":" + m + "pm" : h + ":" + m + " am";

  let day_week = {
    0: "Sunday",
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Sathurday",
  };

  let months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  const time =
    date.getDate() +
    " " +
    months[date.getMonth()] +
    " " +
    date.getFullYear() +
    ", " +
    _time;

  return time;
}

class MessageManager {
  constructor() {
    this._current_page = 0;
    this._load_more = true;
    updateScroll();
  }

  addListener(element_id) {
    let reference = this;
    let page = this._current_page;

    document.addEventListener(
      "scroll",
      function (e) {
        let scrollTop = document.getElementById(element_id).scrollTop;

        if (scrollTop == 0 && reference._load_more === true) {
          reference.addCall();
          page = reference._current_page;
          reference.print();
          sendAjaxRequest(
            "POST",
            `/api/channel/${active_chat.getAttribute("id")}/message`,
            { page },
            function () {
              const response = JSON.parse(this.responseText);

              if (response.errors) {
                console.log("errors");
              } else {
                const new_messages = response[0];
                const load_more = response[1];
                reference.setEverythingLoaded(load_more);
                reference.addMessages(new_messages, page);
              }
            }
          );
        }
      },
      true
    );
  }

  print() {
    console.log(
      "page: " + this._current_page + "| load more: " + this._load_more
    );
  }

  addCall() {
    if (this._load_more === true) this._current_page++;
  }

  setEverythingLoaded(value) {
    this._load_more = value;
  }

  addMessages(messages, pages) {
    console.log(messages);
    let active_chat = document.querySelector(".active_chat").getAttribute("id");
    let current_chat = document.querySelector("#chat-msg" + active_chat);

    for (let m = messages.length - 1; m >= 0; m--) {
      const message = messages[m];

      let image = `
                <img src= "/assets/avatars/${message["photo_path"]}.png" alt="{{$message['username']}} profile picture" />
             `;

      let messageWrapper = document.createElement("div");
      messageWrapper.classList.add(
        "incoming_msg",
        "d-flex",
        "align-items-start"
      );
      messageWrapper.innerHTML = `
              <div class="incoming_msg_img">
                ${image}
              </div>
              <div class="message d-flex flex-column align-items-start"> 
                    <div class="message-header"><span class="author">${
                      message["username"]
                    }</span>
                    <span class="time_date px-2"> ${getDate(
                      message["date"]
                    )} </span></div>
                    <div class="message-content">
                        ${message["content"]}
                    </div>
                </div>
            `;
      current_chat.prepend(messageWrapper);
    }

    const percent = messages.length / (pages * 15);
    console.log(percent);
    msgHistory.scrollTop = msgHistory.scrollHeight * (1 - percent);
  }
}

let manager = new MessageManager();
if (active_chat != null)
  manager.addListener("chat-msg" + active_chat.getAttribute("id"));
