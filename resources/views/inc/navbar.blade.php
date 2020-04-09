<script src="{{asset('js/navbar.js')}}" defer></script>

<nav class="top-navbar">

    <div class="top-menu d-flex flex-row bd-highlight align-items-center justify-content-between">
        
            <div class="hamburger mobile side-menu-item">
                <div class="hamburger-symbol"></div>
                <div class="hamburger-symbol"></div>
                <div class="hamburger-symbol"></div>
            </div>

        <div class="logo">
            <h4 class="mb-0 px-3"><i class="fas fa-drafting-compass"></i> Kick</h4>
        </div>

        <ul class="d-flex align-items-end align-items-center mb-0 mr-3">

            <!--notifications-->
            <li class="px-5 utility ml-3 notification mb-0">
                <a href="#"><i class="fas fa-bell"></i></a>
                <span class="num">4</span>
                <div class="notification-dropdown d-none">
                    <h6 class="notification-title text-center">notifications</h6>
                    <div class="notify_item clickable">
                        <div class="notify_img">
                            <img src="./assets/profile.png" alt="profile_pic" style="width: 50px">
                        </div>
                        <div class="notify_info">
                            <p>Alex commented on the<span>Task Share</span></p>
                            <span class="notify_time">10 minutes ago</span>
                        </div>
                    </div>
                    <div class="notify_item clickable">
                        <div class="notify_img">
                            <img src="./assets/profile.png" alt="profile_pic" style="width: 50px">
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
            <li class="px-2 utility ml-3 mb-0 ">
                <a href="#"><i class="fas fa-user"></i></a>
            </li>
        </ul>
    </div>
</nav>
