<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = "notification";

    /**
     * Indicates if the model should be timestamped.
     *
     * @var bool
     */
    public $timestamps = false;

    public function sender()
    {
        return $this->hasOne(User::class, 'sender_id');
    }

    public function receiver()
    {
        return $this->hasOne(User::class, 'receiver_id');
    }
}
