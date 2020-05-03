<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Event extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = "event";

    /**
     * Indicates if the model should be timestamped.
     *
     * @var bool
     */
    public $timestamps = false;

    public function personal()
    {
        return $this->hasOne(EventPersonal::class);
    }

    public function meeting()
    {
        return $this->hasOne(EventMeeting::class);
    }
}
