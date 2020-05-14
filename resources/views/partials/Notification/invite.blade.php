<li class="invited-notification m-2 p-2 notification-list-item border-bottom">
    <div class="d-flex justify-content-between">
        <div class="d-flex align-items-center">
            @if (is_file(public_path('assets/avatar/'. $elem['photo_path'] .'png' )))
                <img  class="m-2" src="{{ asset('assets/avatars/'.  $elem['photo_path'] .'png') }}" alt="{{ $elem['username']}} profile picture" style = "width:40px" />
            @else
                <img  class="m-2" src="{{ asset('assets/profile.png')}}" alt="{{ $elem['username']}} profile picture" style = "width:40px" />
            @endif
            <p><span class="author-reference">{{$elem['username']}} </span>invited you to the project <span class="project-reference">{{$elem['name']}}</span>           
        </div>
        <p class="timestamp smaller-text m-2">{{date('d M Y, h:i a', strtotime($elem['date']))}}</p>
    </div>
    <button data-invite = "{{$elem['id']}}" type="button" class="custom-button primary-button mx-2">Accept <i class="fas fa-check" aria-hidden="true"></i></button>
    <button data-invite = "{{$elem['id']}}" type="button" class="custom-button secondary-button mx-2">Deny <i class="fas fa-times" aria-hidden="true"></i></button>
</li>