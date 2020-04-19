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

          <ul class="d-flex align-items-end align-items-center mb-0 mr-3">
            <!--notifications-->
            <li class="utility notification mb-0">
              <a href="#"><i class="fas fa-bell"></i></a>
              <span class="num">4</span>
              <div class="notification-dropdown d-none">
                <h6 class="notification-title text-center">notifications</h6>
                <div class="notify_item clickable">
                  <div class="notify_img">
                    <img
                      src="./assets/profile.png"
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
                      src="./assets/profile.png"
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
                      src="./assets/profile.png"
                      alt="profile_pic"
                      style="width: 40px"
                    />
                  </div>
                  <div class="notify_info">
                    <p><a class="nostyle" href="profile.html">Me</a></p>
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
                  <a href="index.html" class="nostyle">Logout</a>
                </div>
              </div>
            </li>
          </ul>
        </div>
      </nav>

<nav class="sidebar-menu">
        <ul>
          <li class="hamburger side-menu-item">
            <div class="hamburger-symbol"></div>
            <div class="hamburger-symbol"></div>
            <div class="hamburger-symbol"></div>
          </li>
          <li class="side-menu-item dropdown">
            <a href="project_overview.html">
              <span class="m-2"><i class="fas fa-home"></i> </span>
              <span class="side-menu-item-title">Project Overview</span>
            </a>
            <ul class="side-menu-dropdown">
              <li class="side-menu-item main-dropdown-title">
                <a href="project_overview.html">
                  <span class="">Project Overview</span>
                </a>
              </li>
              <li class="side-menu-item">
                <a class="" href="project_team.html">
                  <span class="">Members</span>
                </a>
              </li>
              <li class="side-menu-item">
                <a href="activity.html">
                  <span class="">Activity</span>
                </a>
              </li>
            </ul>
          </li>
          <li class="side-menu-item dropdown active">
            <a href="issuelist.html">
              <span class="m-2"><i class="far fa-folder"></i></span>
              <span class="side-menu-item-title">Issues</span>
            </a>
            <ul class="side-menu-dropdown">
              <li class="side-menu-item main-dropdown-title">
                <a class="active" href="issuelist.html">
                  <span class="">Issues</span>
                </a>
              </li>
              <li class="side-menu-item">
                <a href="issuelist.html">
                  <span class="">List</span>
                </a>
              </li>
              <li class="side-menu-item">
                <a href="board.html">
                  <span class="">Boards</span>
                </a>
              </li>
            </ul>
          </li>
          <li class="side-menu-item">
            <a href="chat.html">
              <span class="m-2"><i class="far fa-comment-alt"></i></span>
              <span class="side-menu-item-title">Chat</span>
            </a>
          </li>
        </ul>
      </nav>
