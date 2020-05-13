<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\NotificationAssign;
use App\NotificationEvent;
use App\NotificationInvite;
use App\NotificationKick;
use App\User;
// use App\NotifcationInvite;
// use App\NotifcationEvent;
// use App\NotifcationAssign;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class NotificationController extends Controller
{

    public function show($id)
    {
        $user = User::find($id);

        $kicked_notificatons = NotificationKick::join('notification', 'notification_kicked.notification_id', '=', 'notification.id')->where('receiver_id', '=', $id);
        $invite_notificatons = NotificationInvite::join('notification', 'notification_invite.notification_id', '=', 'notification.id')->where('receiver_id', '=', $id);
        $event_notificatons = NotificationEvent::join('notification', 'notification_event.notification_id', '=', 'notification.id')->where('receiver_id', '=', $id);
        $assign_notificatons = NotificationAssign::join('notification', 'notification_assign.notification_id', '=', 'notification.id')->where('receiver_id', '=', $id);

        return view('pages.notifications', ['kicked_notifications' => $kicked_notificatons, 'invite_notifications' => $invite_notificatons, 'event_notifications' => $event_notificatons, 'assign_notifications' => $assign_notificatons]);
    }

    public function authorizeUser(Request $request)
    {

        if (!Auth::check()) {

            return new Response('Forbidden', 403);

        }

        $pusher = new \Pusher\Pusher(config('broadcasting.connections.pusher.key'), config('broadcasting.connections.pusher.secret'), config('broadcasting.connections.pusher.app_id'));

        echo $pusher->socket_auth(

            $request->input('channel_name'),

            $request->input('socket_id')

        );

    }
}
