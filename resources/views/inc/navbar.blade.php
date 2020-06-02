<script src="{{asset('js/navbar.js')}}" defer></script>

<nav class="top-navbar">
  <div
    class="top-menu d-flex flex-row bd-highlight align-items-center justify-content-between"
  >
    <div class="hamburger mobile side-menu-item">
      <div class="hamburger-symbol"></div>
      <div class="hamburger-symbol"></div>
      <div class="hamburger-symbol"></div>
    </div>
    <div class="logo">
      <a class="nostyle" href="/users/{{ Auth::user()->id }}/projects">
        <h4 class="mb-0 px-3">
          <i class="fas fa-drafting-compass"></i> Kick
        </h4>
      </a>
    </div>

    <ul data-user ="{{ Auth::user()->id }}" class="d-flex align-items-end align-items-center mb-0 mr-3">
      <!--notifications-->
      @php
        $kicked_notifications = \App\NotificationKick::join('notification', 'notification_kick.notification_id', '=', 'notification.id')
        ->join('user', 'user.id', '=', 'sender_id')
        ->join('project', 'project.id', '=', 'project_id')
        ->where('receiver_id', '=', Auth::user()->id)
        ->select('notification_id', 'project_id', 'date', 'receiver_id', 'sender_id', 'username', 'photo_path', 'project.name as name')->get();
        
        $invite_notifications = \App\NotificationInvite::join('notification', 'notification_invite.notification_id', '=', 'notification.id')
            ->join('user', 'user.id', '=', 'sender_id')
            ->join('project', 'project.id', '=', 'project_id')
            ->where('receiver_id', '=', Auth::user()->id)
            ->select('notification_id', 'project_id', 'date', 'receiver_id', 'sender_id', 'username', 'photo_path', 'project.name as name')->get();

        $event_notifications = \App\NotificationEvent::join('notification', 'notification_event.notification_id', '=', 'notification.id')
            ->join('user', 'user.id', '=', 'sender_id')
            ->where('receiver_id', '=', Auth::user()->id)
            ->select('*')->get();

        $assign_notifications = \App\NotificationAssign::join('notification', 'notification_assign.notification_id', '=', 'notification.id')
            ->join('user', 'user.id', '=', 'sender_id')
            ->where('receiver_id', '=', Auth::user()->id)
            ->select('*')->get();

        $notifications = $kicked_notifications->toBase()->merge($invite_notifications)->merge($event_notifications)->merge($assign_notifications)->sortByDesc('date');
      @endphp
      <li class="utility notification mb-0">
        <a href="#"><i class="fas fa-bell"></i></a>
        <span class="num">{{count($notifications)}}</span>
        <div class="notification-dropdown d-none">
          <h6 class="notification-title text-center">notifications</h6>
          
            @foreach($notifications as $notification)
              @break ($loop->index == 2)
              <div class="notify_item clickable">
                <div class="notify_img">
                  <img
                    src="{{ asset('assets/avatars/'.  $notification['photo_path'] . '.png') }}"
                    alt="{{ $notification['username']}} profile picture"
                    style="width: 50px"
                  />
                </div>
                <div class="notify_info">
                  @if ($notification['typeOfNotification'] === 'kick')
                    <p><span class=".author-reference">{{$notification['username']}}</span> kicked you from project <span class=".project-reference">{{$notification['name']}}</span></p>
                  @elseif ($notification ['typeOfNotification'] === 'invite')
                    <p><span class=".author-reference">{{$notification['username']}}</span> invited you to project <span class=".project-reference">{{$notification['name']}}</span></p>
                  @elseif ($notification ['typeOfNotification'] === 'event')
                    <p><span class=".author-reference">{{$notification['username']}}</span> created an event</p>
                  @elseif ($notification ['typeOfNotification'] === 'assign')
                    <p><span class=".author-reference">{{$notification['username']}}</span> assigned you an issue</p>
                  @endif
                  
                  <span class="notify_time">10 minutes ago</span>
                </div>
              </div>
            @endforeach
          <a class="notify_item clickable nostyle" href="/users/{{ Auth::user()->id }}/notifications">
            More(
              @if(count($notifications) > 2)
                 {{count($notifications) - 2}}
              @else
                 0
              @endif
              ) ...
          </a>
        </div>
      </li>
      <!--profile-->
      <li class="px-2 utility ml-3 mb-0 user  ">
        <a href="#"><i class="fas fa-user"></i></a>
        <div class="user-dropdown d-none">
          <h6 class="user-title text-center">Profile</h6>
          <div class="notify_item clickable">
            <div class="notify_img">
              <img
                src="{{asset('assets/profile.png')}}"
                alt="profile_pic"
                style="width: 40px"
              />
            </div>
            <div class="notify_info">
              <p><a class="nostyle" href="/users/{{ Auth::user()->id }}" id="auth-username" data-id="{{ Auth::user()->id }}">{{ Auth::user()->username }}</a></p>
            </div>
          </div>
          <!--https://codepen.io/ste-vg/pen/oNgrYOb-->
          <div class="notify_item clickable d-flex">
            <p class="m-0" id="dark-mode">Dark Mode</p>
            <span class="mt-2 mr-4">
              <label id="switch" class="switch">
              <input type="checkbox" onchange="toggleTheme()" id="slider">
              <span class="slider round"></span>
            </span>
          </div>

          <div class="notify_item clickable d-flex">
          <!-- quick fix -->
          <a class = "nostyle" href="{{ url('/logout') }}" 
            onclick="event.preventDefault();
            document.getElementById('logout-form').submit();">
            Logout
          </a>
            <form id="logout-form" action="{{ url('/logout') }}"  method="POST" style="display: none;">{{ csrf_field() }}</form>
          </div>
        </div>
      </li>
    </ul>
  </div>
</nav>
