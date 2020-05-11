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
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Database\QueryException;



class ChatController extends Controller
{

    protected function validator(array $data)
    {
        return Validator::make($data, [
            'name' => 'required|string|max:255',
            'description' => 'string|max:255',
            'project_id' => 'required|integer',
        ]);
    }

    public function create(Request $request, $id) {

        /*
        Validator::make($request->all(), [
            'name' => 'required|max:255'
        ])->validate(); */
        
       
        $chat = Channel::create([
            'name' => $request->input('name'),
            'description' => $request->input('description'),
            'creation_date' => Carbon::now()->toDateTimeString(),
            'project_id' => $id
        ]);

        return response()->json([$chat]);


       

          

            //$users = Project::find($id)->memberStatus()->join('user', 'user.id', '=', 'member_status.project_id');
           //event(new ChatCreated($id));

            
    }

}
