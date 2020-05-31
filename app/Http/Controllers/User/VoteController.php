<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class VoteController extends Controller {
    
    public function store(Request $request) {

        $request['user_id'] = \Auth::Id();

        $rules = [
            'comment_id' => 'required|integer|exists:comment,id',
            'user_id'    => 'required|integer|exists:user,id',
            'upvote'     => 'required|integer|min:-1|max:1|not_in:0'
        ];

        $request['upvote'] = ($request['upvote'] === '1')? 1 : -1 ;

        $messages = [
            'comment_id.exists' => 'The comment does not exist'
        ];

        $vote = \App\Vote::where('comment_id','=', $request->comment_id)->where('user_id', '=', $request->user_id)->first();

        $validator = Validator::make($request->all(), $rules, $messages);
  
        if ($validator->fails()) {
            return response()->json(['errors'=>$validator->errors(), $request]);
        }
        else if ($vote != null) {
            if ($vote->upvote === $request->upvote) {
                $vote->delete();
                return response()->json(['errors'=> ['Vote deleted'],]);
            }
            else {
                $updated_vote = $vote->update(['upvote' => $request['upvote']]);
                return response()->json(['update', $updated_vote]);
            }

        }
        else{
              $vote = \App\Vote::create([
                  'comment_id' => $request->comment_id,
                  'user_id' =>  $request->user_id,
                  'upvote' => $request->upvote
              ]);
              return response()->json([$vote ,$request->upvote]);
        }

    }
}
