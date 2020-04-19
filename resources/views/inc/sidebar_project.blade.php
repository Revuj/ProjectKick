<nav class="sidebar-menu">
  <ul>
    <li class="hamburger side-menu-item">
      <div class="hamburger-symbol"></div>
      <div class="hamburger-symbol"></div>
      <div class="hamburger-symbol"></div>
    </li>
    <li class="{{(request()->segment(1) == 'projects' && request()->segment(3) == null ) ? 'side-menu-item dropdown active' : 'side-menu-item dropdown'}}">
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
          <a class="{{(request()->segment(3) == 'members') ? 'active' : ''}}" href="project_team.html">
            <span class="">Members</span>
          </a>
        </li>
        <li class="side-menu-item">
          <a class="{{(request()->segment(3) == 'activity') ? 'active' : ''}}" href="activity.html">
            <span class="">Activity</span>
          </a>
        </li>
      </ul>
    </li>
    <li class="{{(request()->segment(1) == 'projects' && (request()->segment(3) == 'issuelist' || request()->segment(3) == 'board')) ? 'side-menu-item dropdown active' : 'side-menu-item dropdown'}}">
      <a href="issuelist.html">
        <span class="m-2"><i class="far fa-folder"></i></span>
        <span class="side-menu-item-title">Issues</span>
      </a>
      <ul class="side-menu-dropdown">
        <li class="side-menu-item main-dropdown-title">
          <a class="" href="issuelist.html">
            <span class="">Issues</span>
          </a>
        </li>
        <li class="side-menu-item">
          <a class="{{(request()->segment(3) == 'issuelist') ? 'active' : ''}}" href="issuelist.html">
            <span class="">List</span>
          </a>
        </li>
        <li class="side-menu-item">
          <a class="{{(request()->segment(3) == 'board') ? 'active' : ''}}" href="board.html">
            <span class="">Boards</span>
          </a>
        </li>
      </ul>
    </li>
    <li class="{{(request()->segment(1) == 'chat') ? 'side-menu-item active' : 'side-menu-item'}}">
      <a href="chat.html">
        <span class="m-2"><i class="far fa-comment-alt"></i></span>
        <span class="side-menu-item-title">Chat</span>
      </a>
    </li>
  </ul>
</nav>
