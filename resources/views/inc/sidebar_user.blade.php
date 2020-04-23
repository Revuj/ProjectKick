<nav class="sidebar-menu">
  <ul>
    <li class="hamburger side-menu-item">
      <div class="hamburger-symbol"></div>
      <div class="hamburger-symbol"></div>
      <div class="hamburger-symbol"></div>
    </li>
    <li class="side-menu-item dropdown">
      <a class="{{(request()->segment(3) == 'projects') ? 'side-menu-item dropdown active' : 'side-menu-item dropdown'}}" href="./projects">
        <span class="m-2"><i class="fas fa-columns"></i></span>
        <span class="side-menu-item-title">Dashboard</span>
      </a>
    </li>
    <li class="side-menu-item dropdown">
      <a class="{{(request()->segment(3) == 'issues') ? 'side-menu-item dropdown active' : 'side-menu-item dropdown'}}" href="my_work.html">
        <span class="m-2"><i class="fas fa-tasks"></i></span>
        <span class="side-menu-item-title">My Work</span>
      </a>
    </li>
    <li class="side-menu-item">
      <a class="{{(request()->segment(3) == 'calendar') ? 'side-menu-item dropdown active' : 'side-menu-item dropdown'}}" href="calendar.html">
        <span class="m-2"><i class="fas fa-calendar-alt"></i></span>
        <span class="side-menu-item-title">Calendar</span>
      </a>
    </li>
    <li class="side-menu-item">
      <a href="searchpage.html">
        <span class="m-2"><i class="fas fa-search"></i></span>
        <span class="side-menu-item-title">Search</span>
      </a>
    </li>
  </ul>
</nav>
