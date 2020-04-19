@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'project'])

@section('title', 'Calendar')

@section('style')
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <link rel="stylesheet" href="{{asset('css/chat.css')}}" />
    <link rel="stylesheet" href="{{asset('css/navbar.css')}}" />
@endsection

@section('script')
    <script src="https://kit.fontawesome.com/23412c6a8d.js"></script>
    <script
      src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
      integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
      integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
      crossorigin="anonymous"
    ></script>
    <script
      src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
      integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
      crossorigin="anonymous"
    ></script>
    <script src="{{asset('js/navbar.js')}}" defer></script>
    <script src="{{asset('js/index.js')}}" defer></script>
@endsection

@section('content')
<div class="main-content-container px-4">
  <nav>
    <ol class="breadcrumb custom-separator">
      <li><a href="#0">lbaw</a></li>
      <li class="current">Chat</li>
    </ol>
  </nav>
  <div class="align-items-end w-100 d-flex">
    <button
      type="button"
      data-toggle="modal"
      data-target="#addChannelModal"
      class="btn btn-success ml-auto"
    >
      <i class="fa fa-plus-circle fa-lg"></i>
      <span>Add Channel</span>
    </button>
  </div>
  <!-- End Page Header -->
  <!-- Default Light Table -->
  <div class="p-0 my-2 chat-container">
    <div class="row container-fluid mx-0 px-0 h-100">
      <div class="col-lg-3 px-0 channels">
        <div class="inbox_msg d-flex flex-column h-100">
          <div class=" headind_channels">
            <h4 class="w-100 font-weight-bold">Channels</h4>
          </div>
          <div class="chat_list active_chat">
            <a class="chat_ib">
              <h5># developers-team</h5>
            </a>
          </div>
          <div class="chat_list">
            <a class="chat_ib">
              <h5>
                # annoucements-hq <span class="unread_msgs">3</span>
              </h5>
            </a>
          </div>
          <div class="chat_list">
            <a class="chat_ib">
              <h5>
                # relaxing-room <span class="unread_msgs">1</span>
              </h5>
            </a>
          </div>
        </div>
      </div>
      <div class="col-lg-9 px-0 h-100 d-flex flex-column" id="details">
        <div class="p-2 border-bottom channel_header">
          <h6 class="m-0">
            <span class="channel_name">#developers-team</span> |
            Discussions about development details
          </h6>
        </div>
          <div class="mesgs d-flex flex-column justify-content-between">
            <div class="msg_history pt-1 px-1">
              <div class="incoming_msg d-flex align-items-start">
                <div class="incoming_msg_img">
                  <img src="https://ca.slack-edge.com/TUX9PC2RG-UV9KNC82Y-g039f4971eb1-512" alt="sunil" />
                </div>
                <div class="message d-flex flex-column align-items-start">
                    <div class="message-header"><span class="author">Bruno Sousa</span><span class="time_date"> 17:12 PM | 3 Days Ago</span></div>
                    <div class="message-content">
                      <p>
                        Boas pessoal,
                      </p>
                      <p>
                        Dado que não é possível fazer "atendimento" presencial, estou aqui disponível para vos ajudar com os projetos / tirar duvidas das 13h às 15h. Podem por as duvidas aqui ou por mensagem.
                      </p>
                      <p>
                        Se preferirem também podemos fazer por videoconferência, mandem mensagem que eu mando um link do Google Hangouts (ou outro que preferirem).
                      </p>
                      <p>
                        Cumprimentos
                      </p>
                    </div>
                </div>
              </div>
              <div class="incoming_msg d-flex align-items-start">
                <div class="incoming_msg_img">
                  <img src="https://ca.slack-edge.com/TUX9PC2RG-UUZKPEREX-ccd6e784fe8b-512" alt="sunil" />
                </div>
                <div class="message d-flex flex-column align-items-start">
                    <div class="message-header"><span class="author">João Varela</span><span class="time_date"> 11:01 AM | Yesterday</span></div>
                    <div class="message-content">
                      <p>
                        Boa noite. Nesta situação de erro, até que tokens devemos ignorar?
                      </p>
                    </div>
                </div>
              </div>
              <div class="incoming_msg d-flex align-items-start">
                <div class="incoming_msg_img">
                  <img src="assets/profile.png" alt="sunil" />
                </div>
                <div class="message d-flex flex-column align-items-start">
                    <div class="message-header"><span class="author">André Esteves</span><span class="time_date"> 16:45 PM | Yesterday</span></div>
                    <div class="message-content">
                      <p>
                        Boas. Neste caso devem ignorar todos o tokens até à “{” e a execução continua a partir daí.
                      </p>
                      <p>
                        A mensagem de erro deve ser apropriada, neste caso seria algo do género a dizer que falta o parentesis “)”
                      </p>
                    </div>
                </div>
              </div>
              <div class="incoming_msg d-flex align-items-start">
                <div class="incoming_msg_img">
                  <img src="https://ca.slack-edge.com/TUX9PC2RG-UUZKPEREX-ccd6e784fe8b-512" alt="sunil" />
                </div>
                <div class="message d-flex flex-column align-items-start">
                    <div class="message-header"><span class="author">João Varela</span><span class="time_date"> 17:12 PM | Yesterday</span></div>
                    <div class="message-content">
                      <p>
                        Muito Obrigado!
                      </p>
                      <p>
                        Abraço
                      </p>
                    </div>
                </div>
              </div>
              <div class="incoming_msg d-flex align-items-start">
                <div class="incoming_msg_img">
                  <img src="assets/profile.png" alt="sunil" />
                </div>
                <div class="message d-flex flex-column align-items-start">
                    <div class="message-header"><span class="author">André Esteves</span><span class="time_date"> 9:45 PM | Today</span></div>
                    <div class="message-content">
                      <p>
                        Bom dia
                      </p>
                      <p>
                        Assim que puderem entrem na call sff:
                      </p>
                      <p>
                        https://meet.google.com/dxd-uksj-vbx
                      </p>
                    </div>
                </div>
              </div>
              <div class="incoming_msg d-flex align-items-start">
                <div class="incoming_msg_img">
                  <img src="https://ca.slack-edge.com/TUX9PC2RG-UUZKPEREX-ccd6e784fe8b-512" alt="sunil" />
                </div>
                <div class="message d-flex flex-column align-items-start">
                    <div class="message-header"><span class="author">João Varela</span><span class="time_date"> 10:40 PM | Today</span></div>
                    <div class="message-content">
                      <p>
                        André Esteves Neste caso devo detetar a troca dos parentísis mas devo fazer parse do body do while?
                      </p>
                    </div>
                </div>
              </div>
              <div class="incoming_msg d-flex align-items-start">
                <div class="incoming_msg_img">
                  <img src="https://ca.slack-edge.com/TUX9PC2RG-UUZKPEREX-ccd6e784fe8b-512" alt="sunil" />
                </div>
                <div class="message d-flex flex-column align-items-start">
                    <div class="message-header"><span class="author">João Varela</span><span class="time_date"> 10:43 PM | Today</span></div>
                    <div class="message-content">
                      <p>
                        Já agora, sempre ficou combinado alguma coisa para podermos falar com o professor sobre a gramática?
                      </p>
                    </div>
                </div>
              </div>
              <div class="incoming_msg d-flex align-items-start">
                <div class="incoming_msg_img">
                  <img src="https://ca.slack-edge.com/TUX9PC2RG-UVDA734P8-eacc4ba7d71f-512" alt="sunil" />
                </div>
                <div class="message d-flex flex-column align-items-start">
                    <div class="message-header"><span class="author">Manuel Serafim</span><span class="time_date"> 17:19 PM | Today</span></div>
                    <div class="message-content">
                      <p>
                        Professor, antes de ser introduzido o gradle nos usavamos o combo jjtree/javacc/javac para compilar.
                      </p>
                      <p>
                        Deparei-me com a seguinte situacao estranha com error checking e funcoes "static":
                      </p>
                      <p>
                        error checking static = gradle nao compila / jjtree&javacc&javac compila
                      </p>
                      <p>
                        error checking normal = gradle compila / jjtree&javacc&javac nao compila
                      </p>
                    </div>
                </div>
              </div>
              <div class="incoming_msg d-flex align-items-start">
                <div class="incoming_msg_img">
                  <img src="https://ca.slack-edge.com/TUX9PC2RG-UVDA734P8-eacc4ba7d71f-512" alt="sunil" />
                </div>
                <div class="message d-flex flex-column align-items-start">
                    <div class="message-header"><span class="author">Manuel Serafim</span><span class="time_date"> 17:50 PM | Today</span></div>
                    <div class="message-content">
                      <p>
                        Tiago Carvalho seria possivel rever connosco hoje a gramatica? ela ja se encontra LL(1) e passa todos os testes
                      </p>
                    </div>
                </div>
              </div>
            </div>
            <div class="type_msg mt-auto">
              <div class="input_msg_write">
                <input
                  type="text"
                  class="write_msg pl-2"
                  placeholder="Type a message"
                />
                <button class="msg_send_btn" type="button">
                  <i class="fa fa-paper-plane-o" aria-hidden="true"></i>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<div
  class="modal fade"
  id="addChannelModal"
  tabindex="-1"
  role="dialog"
  aria-labelledby="addChannelModalLabel"
  aria-hidden="true"
>
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="addChannelModalLabel">
          Create Channel
        </h5>
        <button
          type="button"
          class="close"
          data-dismiss="modal"
          aria-label="Close"
        >
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form>
          <div class="form-group">
            <label for="project-name" class="col-form-label">Name:</label>
            <input type="text" class="form-control" id="project-name" />
          </div>
          <div class="form-group">
            <label for="project_description" class="col-form-label"
              >Small Description:</label
            >
            <input
              type="text"
              class="form-control"
              id="project_description"
            />
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn " data-dismiss="modal">
          Close
        </button>
        <button type="button" class="btn btn-success">Create</button>
      </div>
    </div>
  </div>
</div>
@endsection
