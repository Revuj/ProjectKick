
<li class="assign-notification m-2 p-2 notification-list-item border-bottom">  
  <div class = "d-flex justify-content-between">
    <div class = "d-flex align-items-center justify-content-center">
        @if (is_file(public_path('assets/avatar/'. $elem['photo_path'] .'png' )))
            <img  class="m-2" src="{{ asset('assets/avatars/'.  $elem['photo_path'] .'png') }}" alt="{{ $elem['username']}} profile picture" style = "width:40px" />
        @else
            <img  class="m-2" src="{{ asset('assets/profile.png')}}" alt="{{ $elem['username']}} profile picture" style = "width:40px" />
        @endif            
        <p><span class="author-reference">{{$elem['username']}} </span>assigned you the issue <a class="project-reference nostyle clickable">{{$elem['name']}}</a>
    </div>
    <p class="timestamp smaller-text m-2">{{date('d M Y, h:i a', strtotime($elem['date']))}}</p>
</div>
<button data-notification-type="assign" data-notification="{{$elem['notification_id']}}" type="button" class="custom-button seen-button mx-2">Seen <i class="fas fa-check" aria-hidden="true"></i></button>
</li>
