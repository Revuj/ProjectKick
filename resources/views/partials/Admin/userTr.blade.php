<tr>
    <td data-label="User">
        <img src="assets/profile.png" alt="" />
        <a href="#" class="user-link">{{$user['username']}}</a>
    </td>
    <td data-label="Created">
        {{ date('d M Y, h:i a', strtotime($user['creation_date'])) }}    
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
        <button class="btn btn-outline-success px-1">
        <i class="fa fa-ban fa-check"></i>
        Unban
        </button>
    @else
        <button class="btn btn-outline-danger">
        <i class="fas fa-ban"></i>
         Ban 
        </button>
    @endif
    </td>
</tr>