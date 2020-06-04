<nav class="sidebar-menu">
  <ul>
    <li class="hamburger side-menu-item">
      <div class="hamburger-symbol"></div>
      <div class="hamburger-symbol"></div>
      <div class="hamburger-symbol"></div>
    </li>
    <li class="{{(request()->segment(1) == 'projects' && request()->segment(3) == null ) ? 'side-menu-item dropdown active' : 'side-menu-item dropdown'}}">
      <a href="/projects/{{ $project }}">
        <span class="m-2"><i class="fas fa-home"></i> </span>
        <span class="side-menu-item-title">Project Overview</span>
      </a>
      <ul class="side-menu-dropdown">
        <li class="side-menu-item main-dropdown-title">
          <a href="/projects/{{ $project }}">
            <span class="">Project Overview</span>
          </a>
        </li>
        <li class="side-menu-item">
          <a class="{{(request()->segment(3) == 'members') ? 'active' : ''}}" href="/projects/{{ $project }}/members">
            <span class="">Members</span>
          </a>
        </li>
        <li class="side-menu-item">
          <a class="{{(request()->segment(3) == 'activity') ? 'active' : ''}}" href="/projects/{{ $project }}/activity">
            <span class="">Activity</span>
          </a>
        </li>
      </ul>
    </li>
    <li class="{{(request()->segment(1) == 'projects' && (request()->segment(3) == 'issuelist' || request()->segment(3) == 'board')) ? 'side-menu-item dropdown active' : 'side-menu-item dropdown'}}">
      <a href="/projects/{{ $project }}/issuelist">
        <span class="m-2"><i class="far fa-folder"></i></span>
        <span class="side-menu-item-title">Issues</span>
      </a>
      <ul class="side-menu-dropdown">
        <li class="side-menu-item main-dropdown-title">
          <a class="" href="/projects/{{ $project }}/issuelist">
            <span class="">Issues</span>
          </a>
        </li>
        <li class="side-menu-item">
          <a class="{{(request()->segment(3) == 'issuelist') ? 'active' : ''}}" href="/projects/{{ $project }}/issuelist">
            <span class="">List</span>
          </a>
        </li>
        <li class="side-menu-item">
          <a class="{{(request()->segment(3) == 'board') ? 'active' : ''}}" href="/projects/{{ $project }}/board">
            <span class="">Boards</span>
          </a>
        </li>
      </ul>
    </li>
    <li class="{{(request()->segment(3) == 'chats') ? 'side-menu-item active' : 'side-menu-item'}}">
      <a href="/projects/{{ $project }}/chats">
        <span class="m-2"><i class="far fa-comment-alt"></i></span>
        <span class="side-menu-item-title">Chat</span>
      </a>
    </li>
    <li class="{{(request()->segment(1) == 'help') ? 'side-menu-item active' : 'side-menu-item'}}">
      <a href="/help">
        <span class="m-2"><i class="fas fa-question"></i></span>
        <span class="side-menu-item-title">Help</span>
      </a>
    </li>
  </ul>
</nav>
