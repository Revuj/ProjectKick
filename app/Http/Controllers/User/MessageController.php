<?php

namespace App\Http\Controllers\User;
use App\Http\Controllers\Controller;
use App\Message;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Auth\Access\Response;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Database\QueryException;
use App\Events\MyEvent;




class MessageController extends Controller
{
    
    public function create(Request $request, $id) {
  

    $message = new Message();
    $message->content = $request->input('content');
    $message->date = Carbon::now()->toDateTimeString();
    $message->channel_id = $request->input('channel_id');
    $message->user_id = Auth::id();
    $user = User::select('username', 'photo_path')
    ->where('id', $message->user_id)->first();

    //event(new MyEvent($message));

    event(new MyEvent($message));

    

    
    //$message->save();
    //return response()->json([ 
        //  $message, $user
    //]);

    }

}
