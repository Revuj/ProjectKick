@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'project', 'project' => $project->id])

@section('title', 'Chat')

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
    <script src="{{asset('js/chat.js')}}" defer></script>

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
          @if(!empty($first_channel))
          <div id="{{$first_channel['channel_id'] }}" data-chat = "{{$first_channel['channel_id'] }}" class="clickable chat_list active_chat d-flex justify-content-between align-items-center">
              <a class="chat_ib">
                <h5 ># {{ $first_channel['channel_name'] }}</h5>
              </a>
              <button type="button" class="btn delete-channel-button ml-auto text-white " data-toggle="modal" data-target="#delete-channel-modal" data-channel="{{$first_channel['channel_id'] }}">
                <i class="fas fa-trash-alt"></i>
              </button>
          </div>
          @endif

          @if(count($channels))
            @foreach($channels as $channel)
              <div id="{{$channel['channel_id'] }}" data-chat = "{{$channel['channel_id'] }}" class="clickable chat_list d-flex justify-content-between align-items-center">
                <a class="chat_ib">
                  <h5 ># {{ $channel['channel_name'] }}</h5>
                </a>
                <button type="button" class="btn delete-channel-button ml-auto text-white" data-toggle="modal" data-target="#delete-channel-modal" data-channel="{{$channel['channel_id'] }}">
                  <i class="fas fa-trash-alt"></i>
                </button>
              </div>
            @endforeach
          @endif

        </div>
      </div>
    
      <div class="col-lg-9 px-0 h-100 d-flex flex-column" id="details">
        <div class="p-2 border-bottom channel_header">

          @if(!empty($first_channel))
          <h6 class="m-0" id = "chat-info{{$first_channel['channel_id']}}">
            <span class="channel_name"># {{ $first_channel['channel_name'] }}</span> |
            <span class="channel_description"> {{ $first_channel['channel_description'] }}</span>
          </h6>
          @else
            <span class = "h-100 h4 ">No channels available</span>
          @endif


          @if(count($channels))
            @foreach($channels as $channel)
            <h6 class="m-0 d-none" id = "chat-info{{$channel['channel_id']}}">
              <span class="channel_name"># {{ $channel['channel_name'] }} | </span> 
              <span class="channel_description">{{ $channel['channel_description'] }}</span>
            </h6>
            @endforeach
          @endif

        </div>
          <div class="mesgs d-flex flex-column justify-content-between">
            <div class="msg_history pt-1 px-1 d-flex flex-column">
            
            <div id = "chat-msg{{$first_channel['channel_id']}}">
            @if(!empty($first_channel))
              @foreach($first_channel['messages'] as $message)
                  <div class="incoming_msg d-flex align-items-start">
                        <div class="incoming_msg_img">
                        @if (is_file(public_path('assets/avatar/'. $message['photo_path'] .'png' )))
                          <img src="{{ asset('assets/avatars/'.  $message['photo_path'] .'png') }}" alt="{{ $message['username']}} profile picture" />
                        @else
                          <img src="{{ asset('assets/profile.png')}}" alt="{{ $message['username']}} profile picture" />
                        @endif
                        </div>
                        <div class="message d-flex flex-column align-items-start">  <!--17:12 PM | 3 Days Ago--> 
                            <div class="message-header"><span class="author">{{ $message['username']}}</span><span class="time_date px-2"> {{date('d M Y, h:i a', strtotime($message['date']))}} </span></div>
                            <div class="message-content">
                              {{ $message['content']}}
                            </div>
                        </div>
                  </div>
                @endforeach
              @endif
              </div>
            
            @if(count($channels))
              @foreach($channels as $channel)
              <div id = "chat-msg{{$channel['channel_id']}}" class = "d-none">
                @foreach($channel['messages'] as $message)
                <div class="incoming_msg d-flex align-items-start">
                          <div class="incoming_msg_img">
                          @if (is_file(public_path('assets/avatar/'. $message['photo_path'] .'png' )))
                            <img src="{{ asset('assets/avatars/'.  $message['photo_path'] .'png') }}" alt="{{ $message['username']}} profile picture" />
                          @else
                            <img src="{{ asset('assets/profile.png')}}" alt="{{ $message['username']}} profile picture" />
                          @endif
                          </div>
                          <div class="message d-flex flex-column align-items-start">  <!--17:12 PM | 3 Days Ago--> 
                              <div class="message-header"><span class="author">{{ $message['username']}}</span><span class="time_date px-2"> {{ $message['date']}} </span></div>
                              <div class="message-content">
                                {{ $message['content']}}
                              </div>
                          </div>
                    </div>
                    @endforeach
              </div>
              @endforeach
            @endif



            @if(!empty($first_channel))
            <div class="type_msg mt-auto">
              <div class="input_msg_write">
                <input
                  type="text"
                  class="write_msg pl-2"
                  placeholder="Type a message"
                  id = "messageToSend"
                />
                <button class="msg_send_btn" type="button">
                  <i class="fa fa-paper-plane-o" aria-hidden="true"></i>
                </button>
              </div>
            </div>
          @endif


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
        <button data-project = "{{$project_id === null ? '' : $project_id}}" data-dismiss="modal" id = "create-chat" type="button" class="btn btn-success">Create</button>
      </div>
</div>
  </div>
</div>

<!-- Delete list modal -->
<div
class="modal fade"
id="delete-channel-modal"
tabindex="-1"
role="dialog"
aria-labelledby="exampleModalLabel"
aria-hidden="true"
>
<div class="modal-dialog" role="document">
  <div class="modal-content">
    <div class="modal-header">
      <h5 class="modal-title" id="exampleModalLabel">Delete</h5>
      <button
        type="button"
        class="close"
        data-dismiss="modal"
        aria-label="Close"
      >
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <div class="modal-body text-left">
      <p>
        Are you sure you want to delete this channel?
      </p>
    </div>
    <div class="modal-footer">
      <button
        type="button"
        class="btn btn-secondary"
        data-dismiss="modal"
      >
        Close
      </button>
      <button
        id="delete-channel-button"
        type="button"
        data-dismiss="modal"
        class="btn btn-primary btn-danger"
      >
        Delete
      </button>
    </div>
  </div>
</div>
</div>
</div>
@endsection
