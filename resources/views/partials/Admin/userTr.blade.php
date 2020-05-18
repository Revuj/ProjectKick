<tr>
    <td data-label="User">
        <img src="{{asset('assets/avatars/' . $user['photo_path'] . '.png')}}" alt=" {{$user['username']}} profile picture" />
        <a href="#" class="user-link">{{$user['username']}}</a>
    </td>
    <td data-label="Created" class = "text-center">
        {{ date('d M Y', strtotime($user['creation_date'])) }}    
    </td>
    <td data-label="Status" class="align-center">
        <span class="badge {{(($user['is_banned']) ? 'text-danger' : 'text-success' )}}">
          @if($user['is_banned'])
            banned
          @else
            normal
          @endif
        </span>
    </td>
    <td class = "text-center" data-label="Email">
        <a href="#">{{$user['email']}}</a>
    </td>
    <td class = "text-center">
    @if($user['is_banned'])
        <button class="btn btn-outline-success px-1 unban" data-target = "{{$user['id']}}">
        <i class="fa fa-ban fa-check"></i>
        Unban
        </button>
    @else
        <button class="btn btn-outline-danger ban" data-target = "{{$user['id']}}">
        <i class="fas fa-ban"></i>
         Ban 
        </button>
    @endif
    </td>
</tr>