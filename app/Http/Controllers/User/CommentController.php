<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;



class CommentController extends Controller
{
    public function store(Request $request)
    {

        $rules = [
            'user_id' => 'required|integer',
            'content' => 'required|string|min:1|max:100',
            'issue_id' => 'required|integer'
        ];

        $messages = [
            'content.required' => 'The comment must not be empty'
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()]);
        } else {
            $request->creation_date = \Carbon\Carbon::now()->toDateTimeString();
            $post = \App\Comment::create($request->all())->refresh();
            return response()->json([$post, \Auth::User()]);
        }
    }
}
