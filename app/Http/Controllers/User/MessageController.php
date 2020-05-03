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




class MessageController extends Controller
{
    public function create(Request $request, $id) {
        try {

            $message = new Message();
            $message->content = $request->input('content');
            $message->date = Carbon::now()->toDateTimeString();
            $message->channel_id = $request->input('channel_id');
            $message->user_id = Auth::id();
            $user = User::select('username', 'photo_path')
            ->where('id', $message->user_id)->first();
            
            //$message->save();
            return response()->json([ 
                $message, $user
            ]);

        } catch (ModelNotFoundException $err) {
            return response()->json([], 404);
        } catch (QueryException $err) {
            return response()->json([
                'message' => 'Unable to send message',
            ], 400);
        }
    }

}
