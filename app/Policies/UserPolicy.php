<?php

namespace App\Policies;

use App\User;
use Illuminate\Auth\Access\HandlesAuthorization;


class UserPolicy
{
    use HandlesAuthorization;

    /**
     * Determine whether the user can view the model.
     *
     * @param  \App\User  $user
     * @param  \App\User  $model
     * @return mixed
     */
    public function view(User $user, User $model)
    {
        return $model->is_admin === false;
    }

    /**
     * Determine whether the user owns the model
     *
     * @param  \App\User  $user
     * @param  \App\User  $model
     * @return mixed
     */
    public function own(User $user, User $model)
    {
        return $user->id === $model->id;
    }


    /**
     * Determine whether the user can restore the model.
     *
     * @param  \App\User  $user
     * @param  \App\User  $model
     * @return mixed
     */
    public function restore(User $user, User $model)
    {
        return $user->isAdmin();
    }

}
