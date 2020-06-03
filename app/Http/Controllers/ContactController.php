<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Mail;

class ContactController extends Controller
{
    public function contact(Request $request)
    {
        $rules = [
            'name' => 'required|string',
            'email' => 'required|string'
        ];

        $messages = [
            'required' => "Please insert a :attribute"
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            return view('pages.contact')->withErrors($validator->errors());
        }

        $data = array('name' => $request->input('name'), "email" => $request->input('email'), "body" => $request->input('message'));

        $email = $request->input('email');

        Mail::send(
            'emails.mail',
            $data,
            function ($message) use ($email) {
                $message->from($email);
                $message->to('kicklbaw@gmail.com');
            }
        );

        return view('pages.contact')->with('status', 'Email sent successfully!');
    }
}
