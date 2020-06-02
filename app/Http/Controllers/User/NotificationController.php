<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\MemberStatus;
use App\Notification;
use App\NotificationAssign;
use App\NotificationEvent;
use App\NotificationInvite;
use App\NotificationKick;
use App\User;
use Illuminate\Auth\Access\Response;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class NotificationController extends Controller
{

    public function show($id)
    {
        $user = User::findOrFail($id);

        $kicked_notifications = NotificationKick::join('notification', 'notification_kick.notification_id', '=', 'notification.id')
            ->join('user', 'user.id', '=', 'sender_id')
            ->join('project', 'project.id', '=', 'project_id')
            ->where('receiver_id', '=', $id)
            ->select('notification_id', 'project_id', 'date', 'receiver_id', 'sender_id', 'username', 'photo_path')->get();

        $invite_notifications = NotificationInvite::join('notification', 'notification_invite.notification_id', '=', 'notification.id')
            ->join('user', 'user.id', '=', 'sender_id')
            ->join('project', 'project.id', '=', 'project_id')
            ->where('receiver_id', '=', $id)
            ->select('notification_id', 'project_id', 'date', 'receiver_id', 'sender_id', 'username', 'photo_path')->get();

        $event_notifications = NotificationEvent::join('notification', 'notification_event.notification_id', '=', 'notification.id')
            ->join('user', 'user.id', '=', 'sender_id')
            ->where('receiver_id', '=', $id)
            ->select('*')->get();

        $assign_notifications = NotificationAssign::join('notification', 'notification_assign.notification_id', '=', 'notification.id')
            ->join('user', 'user.id', '=', 'sender_id')
            ->where('receiver_id', '=', $id)
            ->select('*')->get();

        $result = $kicked_notifications->toBase()->merge($invite_notifications)->sortByDesc('date');
        return view('pages.notifications', [
            'kicked_notifications' => $kicked_notifications,
            'invite_notifications' => $invite_notifications,
            'meeting_notifications' => $event_notifications,
            'assign_notifications' => $assign_notifications,
            'all' => $result,
            'user' => $user->id,
        ]);
    }

    public function deleteInvite(Request $request, $id)
    {
        $notification = Notification::find($id);

        $invite = NotificationInvite::where('notification_id', '=', $id);

        DB::beginTransaction();

        try {
            $notification->delete();
            $invite->delete();
            DB::commit();
        } catch (ModelNotFoundException $err) {
            DB::rollback();
            return response()->json([], 404);
        } catch (QueryException $err) {
            DB::rollback();
            return response()->json([
                'message' => 'Invalid delete.',
            ], 400);
        }

        return response()->json([$notification, $invite]);
    }

    public function acceptInvite(Request $request, $id)
    {

        try {
            MemberStatus::create([
                'departure_date' => null,
                'user_id' => Auth::id(),
                'project_id' => $id,
            ]);

        } catch (ModelNotFoundException $err) {
            DB::rollback();
            return response()->json([], 404);
        } catch (QueryException $err) {
            DB::rollback();
            return response()->json([
                'message' => 'Invalid delete.',
            ], 400);
        }
        return response()->json([$id]);
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
