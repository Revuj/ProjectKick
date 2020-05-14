@extends('layouts.app', ['hide_navbar' => false, 'hide_footer' => true, 'sidebar' => 'user'])

@section('title', 'Notifications')

@section('style')
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"
    integrity="sha256-UhQQ4fxEeABh4JrcmAJ1+16id/1dnlOEVCFOxDef9Lw=" crossorigin="anonymous" />
  <link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"
    integrity="sha256-kksNxjDRxd/5+jGurZUJd1sdR2v+ClrCl3svESBaJqw=" crossorigin="anonymous" />
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    
    <link rel="stylesheet" href="{{asset('css/notification.css')}}" />
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
    <script src="{{asset('js/index.js')}}" defer></script>
    <script src="{{asset('js/notifications.js')}}" defer></script>
    <script src="{{asset('js/navbar.js')}}" defer></script>
@endsection


@section('content')

<div class="main-content-container px-4">
  <nav>
    <ol class="breadcrumb custom-separator">
      <li class="current">Notifications</li>
    </ol>
  </nav>
  <div id="notifications-list-container" class="pt-1 mb-0">
    <ul class="d-flex border-bottom nav-links p-2">
      <li id="assigned-notifications" class = "clickable">
        Assigned <span class="type-counter">{{count($assign_notifications)}}</span>
      </li>
      <li id="invited-notifications" class = "clickable">
        Invited <span class="type-counter">{{count($invite_notifications)}}</span>
      </li>
      <li id="meetings-notifications" class = "clickable">
        Meetings <span class="type-counter">{{count($meeting_notifications)}}</span>
      </li>
      <li id="kicked-notifications" class = "clickable">
        kicked <span class="type-counter">{{count($kicked_notifications)}}</span>
      </li>
      <li id="all-notifications" class="active clickable">
        All <span class="type-counter">{{count($all)}}</span>
      </li>
    </ul>
  </div>
  <ul class="p-0 m-2 notification-container active" id = "all">
    @foreach($all as $elem)
      @if ($elem['typeOfNotification'] === 'kick')
        @include('partials.Notification.kick', $elem)
      @elseif ($elem ['typeOfNotification'] === 'invite')
        @include('partials.Notification.invite', $elem)
      @endif
    @endforeach
  </ul>

  <ul class="p-0 m-2 notification-container d-none" id = "invited">
    @foreach($invite_notifications as $elem)
        @include('partials.Notification.invite', $elem)
    @endforeach
  </ul>

  <ul class="p-0 m-2 notification-container d-none" id = "kicked">
    @foreach($kicked_notifications as $elem)
        @include('partials.Notification.kick', $elem)
    @endforeach
  </ul>

  <ul class="p-0 m-2 notification-container none" id = "meetings">

  </ul>

  <ul class="p-0 m-2 notification-container none" id = "assigned">

</ul>



</div>
@endsection
