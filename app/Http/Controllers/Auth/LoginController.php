<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use \Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;




class LoginController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles authenticating users for the application and
    | redirecting them to your home screen. The controller uses a trait
    | to conveniently provide its functionality to your applications.
    |
    */

    use AuthenticatesUsers;

    
    protected function authenticated(Request $request, $user)
    {
        if ( $user->is_admin ) {// do your magic here
        return redirect('/admin/' . Auth::id() );
        }

        return redirect('/users/' . Auth::id() . '/projects');
    }

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest')->except('logout');
    }

    public function getUser(){
        return $request->user();
    }

    protected function credentials(Request $request)
    {
        return array_merge(
            $request->only($this->username(), 'password'),
            ['is_banned' => false]
        );
    }
    
    public function username() {
        $loginType = request()->input('username');
        $this->username = filter_var($loginType, FILTER_VALIDATE_EMAIL) ? 'email' : 'username';
        request()->merge([$this->username => $loginType]);
        return property_exists($this, 'username') ? $this->username : 'email';
    }

    protected function validateLogin(Request $request)
    {
        $messages = [
            'username.required' => 'Email or username cannot be empty',
            'email.exists' => 'Email or username already registered',
            'username.exists' => 'Username is already registered',
            'password.required' => 'Password cannot be empty',
        ];

        $request->validate([
            'username' => 'required|string',
            'password' => 'required|string',
            'email' => 'string|exists:users',
        ], $messages);
    }

    /*
     * In case of failure redirect
     
    public function home() {
        return redirect('login');
    }
    */


}
