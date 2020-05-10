<?php

/*
|--------------------------------------------------------------------------
| Broadcast Channels
|--------------------------------------------------------------------------
|
| Here you may register all of the event broadcasting channels that your
| application supports. The given channel authorization callbacks are
| used to check if an authenticated user can listen to the channel.
|
 */

Broadcast::channel('user.{userId}', function ($user, $id) {
    //return (int) $user->id === (int) $id;
    return true;
});

Broadcast::channel('private-groups.{id}', function ($user, $group) {
    // return $group->hasUser($user->id);
    return true;
});
