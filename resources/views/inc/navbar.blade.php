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
      <a class="nostyle" href="my_projects.html">
        <h4 class="mb-0 px-3">
          <i class="fas fa-drafting-compass"></i> Kick
        </h4>
      </a>
    </div>

    <ul data-user ="{{ Auth::user()->id }}" class="d-flex align-items-end align-items-center mb-0 mr-3">
      <!--notifications-->
      <li class="utility notification mb-0">
        <a href="#"><i class="fas fa-bell"></i></a>
        <span class="num">4</span>
        <div class="notification-dropdown d-none">
          <h6 class="notification-title text-center">notifications</h6>
          <div class="notify_item clickable">
            <div class="notify_img">
              <img
                src="{{asset('assets/profile.png')}}"
                alt="profile_pic"
                style="width: 50px"
              />
            </div>
            <div class="notify_info">
              <p>Alex commented on the<span>Task Share</span></p>
              <span class="notify_time">10 minutes ago</span>
            </div>
          </div>
          <div class="notify_item clickable">
            <div class="notify_img">
              <img
                src="{{asset('assets/profile.png')}}"
                alt="profile_pic"
                style="width: 50px"
              />
            </div>
            <div class="notify_info">
              <p>Alex commented on the<span>Task Share</span></p>
              <span class="notify_time">10 minutes ago</span>
            </div>
          </div>
          <div class="notify_item clickable">
            More(2) ...
          </div>
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
