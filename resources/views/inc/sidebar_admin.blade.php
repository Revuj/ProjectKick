<nav class="sidebar-menu">
  <ul>
    <li class="hamburger side-menu-item">
      <div class="hamburger-symbol"></div>
      <div class="hamburger-symbol"></div>
      <div class="hamburger-symbol"></div>
    </li>
    <li class="{{(request()->segment(2) == null) ? 'side-menu-item dropdown active' : 'side-menu-item dropdown'}}">
      <a href="#">
        <span class="m-2"><i class="fas fa-chart-line"></i></span>
        <span class="side-menu-item-title">Dashboard</span>
      </a>
    </li>
    <li class="{{(request()->segment(2) == 'reports') ? 'side-menu-item dropdown active' : 'side-menu-item dropdown'}}">
      <a href="#">
        <span class="m-2"><i class="fas fa-folder"></i></span>
        <span class="side-menu-item-title">User Reports</span>
      </a>
    </li>
    <li class="{{(request()->segment(2) == 'search') ? 'side-menu-item dropdown active' : 'side-menu-item dropdown'}}">
      <a href="/admin/search">
        <span class="m-2"><i class="fas fa-search"></i></span>
        <span class="side-menu-item-title">Search</span>
      </a>
    </li>
  </ul>
</nav>
