
const ENTER_KEY_CODE = 13;
const available_chats = document.querySelectorAll('.chat_list');
const sendButton = document.querySelector('.msg_send_btn');
const message = document.querySelector('#messageToSend');
const create_chat_btn = document.querySelector('#create-chat');
let project_id = create_chat_btn.getAttribute('data-project');


/**
 * Swaps visible chats when one is clicked
 */
function changeChat() {
    let chat = this;
    let active_chat = document.querySelector('.active_chat');
    if (active_chat == chat) return;

    let currently_active_id = active_chat.getAttribute('data-chat');
    let new_active_id = chat.getAttribute('data-chat')

    let currently_active_description = document.getElementById('chat-info' + currently_active_id);
    let new_active_description = document.getElementById('chat-info' + new_active_id);

    let currently_active_chat = document.getElementById('chat-msg' + currently_active_id);
    let new_ative_chat_msg = document.getElementById('chat-msg' + new_active_id);

    currently_active_description.classList.add('d-none');
    currently_active_chat.classList.add('d-none');


    new_active_description.classList.remove('d-none');
    new_ative_chat_msg.classList.remove('d-none');

    active_chat.classList.remove('active_chat');
    chat.classList.add('active_chat');

}


available_chats.forEach(chat =>
    chat.addEventListener('click', changeChat.bind(chat), false));

/**
 *  sends message when click on button
 */
if (sendButton !== null) {
    sendButton.addEventListener('click', (e) => {
        let content = message.value
        if (content.length === 0) return;
        requestCreateMsg();
        emptyInput(message);
    });
}

/**
 * sends message when pressed enter
 */
if (message !== null) {
    message.addEventListener('keyup', () => {
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
    const active_chat = document.querySelector('.active_chat').getAttribute('data-chat')
    let url = `/api/chat/${active_chat}/messages`;
    console.log(active_chat);

    sendAjaxRequest('put', url, {
        'content': message.value,
        'channel_id': active_chat
    }, messageHandler);
}

/**
 * response handler to the new message request
 */
function messageHandler() {
    const response = JSON.parse(this.responseText);
    if ('message' in response) {
        // show error on screen
    }
    else {
        drawMessageTemplate(response[0], response[1]);
    }
}

// missing images
/**
 * template to add message to the page
 * @param {message information} message 
 * @param {user information} author 
 */
function drawMessageTemplate(message, author) {

    let active_chat = document.querySelector('.active_chat').getAttribute('data-chat');
    let current_chat = document.querySelector('#chat-msg' + active_chat);

    let image = `
    @if (is_file(public_path('assets/avatar/'. $message['photo_path'] .'png' )))
    <img src="{{ asset('assets/avatars/'.$message['photo_path'] .'png') }}" alt="{{$message['username']}} profile picture" />
    @else
    <img src="{{ asset('assets/profile.png')}}" alt="{{$message['username']}} profile picture" />
    @endif
     `;


    //console.log(fileExists('/public/assets/profile.png'))

    let messageWrapper = document.createElement('div')
    messageWrapper.classList.add('incoming_msg', 'd-flex', 'align-items-start')
    messageWrapper.innerHTML = `
      <div class="incoming_msg_img">
      </div>
      <div class="message d-flex flex-column align-items-start">  <!--17:12 PM | 3 Days Ago-->
            <div class="message-header"><span class="author">${author['username']}</span>
            <span class="time_date px-2"> ${message['date']} </span></div>
            <div class="message-content">
            ${message['content']}
            </div>
        </div>
    `;
    current_chat.appendChild(messageWrapper);
}

/**
 * button trigger to create a new project
 */
create_chat_btn.addEventListener('click', (e) => {
    let chat_name = document.querySelector('#project-name');
    let chat_description = document.querySelector('#project_description');
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
    sendAjaxRequest('put', url, {
        'name': name,
        'description': description
    }, newChatHandler);
}

/**
 * response handler to the ajax request to create a new project
 */
function newChatHandler() {
    const response = JSON.parse(this.responseText);
    if ('message' in response) {
        // show error on screen
    }
    else {
        addChatTemplate(response[0]);
    }
}

/**
 * template to add the new project to the page
 * @param {chat data} chat
 */
function addChatTemplate(chat) {

    /*add to the left side */
    let inbox = document.querySelector('.inbox_msg');
    const inbox_template = `
    <div data-chat = "${chat['id']}" class="clickable chat_list">
      <a class="chat_ib">
        <h5># ${chat['name']}</h5>
      </a>
    </div>
    `;
    inbox.innerHTML += inbox_template;

    let channel_header = document.querySelector('.channel_header');
    const header_template = `
    <h6 class="m-0 d-none" id = "chat-info${chat['id']}">
        <span class="channel_name">#  ${chat['name']}  | </span> 
        <span class="channel_description"> ${chat['description']} </span>
     </h6>
    `;
    channel_header.innerHTML += header_template;

    /*add listenners */
    let new_chat = document.querySelector(`div[data-chat = "${chat["id"]}" ]`);
    new_chat.addEventListener('click', changeChat);

}






