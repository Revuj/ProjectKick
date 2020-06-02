<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Message extends Model
{
    public $timestamps = false;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'message';

    /**
     * @var array
     */
    protected $fillable = [ 'channel_id', 'user_id', 'content'];

    /**
     * @return
     */
    public function channel()
    {
        return $this->belongsTo(Channel::class, 'channel_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

}