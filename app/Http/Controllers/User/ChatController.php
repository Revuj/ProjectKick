<?php

namespace App\Http\Controllers\User;
use App\Http\Controllers\Controller;
use Carbon\Carbon;

use App\Channel;
use App\Project;
use App\User;
use App\Events\ChatCreated;
use Illuminate\Http\Request;
use Illuminate\Auth\Access\Response;
use Illuminate\Support\Facades\Validator;



class ChatController extends Controller
{

    public function create(Request $request, $id) {

        /*
        Validator::make($request->all(), [
            'name' => 'required|max:255'
        ])->validate(); */
       
            $chat = new Channel();
            $chat->name = $request->input('name');
            $chat->description = $request->input('description');
            $chat->creation_date = Carbon::now()->toDateTimeString();
            $chat->project_id = $id;

            $users = Project::find($id)->memberStatus()->join('user', 'user.id', '=', 'member_status.project_id');

           //event(new ChatCreated($id));

           return response()->json([$chat]);
            
    }

}
